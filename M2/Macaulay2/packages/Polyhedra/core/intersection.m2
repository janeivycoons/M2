--   INPUT : '(M,v,N,w)',  where all four are matrices (although v and w are only vectors), such
--     	    	      	  that the polyhedron is given by P={x | Mx<=v and Nx=w} 
--  OUTPUT : 'P', the polyhedron
intersection(Matrix,Matrix,Matrix,Matrix) := (M,v,N,w) -> (
   << "Warning: This method is deprecated. Please consider using polyhedronFromHData instead." << endl;
   polyhedronFromHData(M,v,N,w)
)


--   INPUT : '(M,N)',  two matrices where either 'P' is the Cone {x | Mx<=0, Nx=0} if 'M' and 'N' have the same source space 
--     	    	       or, if 'N' is only a Column vector the Polyhedron {x | Mx<=v} 
--  OUTPUT : 'P', the Cone or Polyhedron
intersection(Matrix,Matrix) := (M,N) -> (
   << "Warning: This method is deprecated. Please consider using ";
	-- Checking for input errors
	if ((numColumns M =!= numColumns N and numColumns N =!= 1) or (numColumns N == 1 and numRows M =!= numRows N)) and N != 0*N then 
		error("invalid condition vector for half-spaces");
	-- Decide whether 'M,N' gives the Cone C={p | M*p >= 0, N*p = 0}
	if numColumns M == numColumns N and numColumns N != 1 then (
      << "coneFromHData instead." << endl;
      coneFromHData(M,N)
	-- or the Polyhedron P={p | M*p >= N != 0}
	) else (	
      << "polyhedronFromHData instead." << endl;
      polyhedronFromHData(M, N)
   )
)
   

intersection Matrix := M -> (
   << "Warning: This method is deprecated. Please consider using coneFromHData instead." << endl;
   coneFromHData M
)


--   INPUT : '(P1,P2)',  two polyhedra 
--  OUTPUT : 'P', the polyhedron that is the intersection of both
intersection(Polyhedron,Polyhedron) := (P1,P2) -> (
	-- Checking if P1 and P2 lie in the same space
	if ambDim(P1) =!= ambDim(P2) then error("Polyhedra must lie in the same ambient space");
   C1 := getProperty(P1, underlyingCone);
   C2 := getProperty(P2, underlyingCone);
   C12 := intersection(C1, C2);
   result := new HashTable from {
      underlyingCone => C12
   };
   polyhedron result
)





--   INPUT : '(C1,C2)',  two Cones
--  OUTPUT : 'C', the Cone that is the intersection of both
intersection(Cone,Cone) := (C1,C2) -> (
	-- Checking if C1 and C2 lie in the same space
	if ambDim(C1) =!= ambDim(C2) then error("Cones must lie in the same ambient space");
	M := halfspaces C1 || halfspaces C2;
	N := hyperplanes C1 || hyperplanes C2;
	coneFromHData(M,N)
)
   
   
   
--   INPUT : '(C,P)',  a Cone and a Polyhedron
--  OUTPUT : 'Q', the Polyhedron that is the intersection of both
intersection(Cone,Polyhedron) := (C,P) -> intersection(polyhedron C, P)



--   INPUT : '(P,C)',  a Polyhedron and a Cone
--  OUTPUT : 'Q', the Polyhedron that is the intersection of both
intersection(Polyhedron,Cone) := (P,C) -> intersection(C,P)


--   INPUT : 'L',   a list of Cones, Polyhedra, other Lists and Sequences of matrices
--           Will just turn everything in the list into Polyhedra and then intersect this.
--           Works recursive.
intersection List := L -> (
   L = apply(L, 
      l -> (
         if instance(l, List) or instance(l, Sequence) then intersection l
         else l
      )
   );
   result := L#0;
   for i from 1 to #L-1 do (
      result = intersection(result, L#i)
   );
   result
)

