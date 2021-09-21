extends Node

func load_mdl(path: String) -> Mesh:
	if path == null:
		return null
	var ext := path.get_extension()
	
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var mdlFile := File.new()
	var errorCheck = mdlFile.open(path, File.READ)
	if errorCheck != OK:
		print("cannot open file at path[", path,"]")
		mdlFile.close()
		return null
	
	var newMsh : TriMesh
	if ext.matchn("obj"):
		newMsh = _import_obj(mdlFile)
	else:
		print("[", ext,"] is not a supported format!")
		mdlFile.close()
		return null
	
	var hasUV := newMsh.uvs.size() > 0
	var hasNrm := newMsh.normals.size() > 0
	
	for i in newMsh.indices.size():
		var triangle : Triangle = newMsh.indices[i]
		if hasUV:
			st.add_uv(newMsh.uvs[triangle.uv_id_0])
		if hasNrm:
			st.add_normal(newMsh.normals[triangle.nrm_id_0])
		st.add_vertex(newMsh.vertices[triangle.id_0])
		
		if hasUV:
			st.add_uv(newMsh.uvs[triangle.uv_id_1])
		if hasNrm:
			st.add_normal(newMsh.normals[triangle.nrm_id_1])
		st.add_vertex(newMsh.vertices[triangle.id_1])
		
		if hasUV:
			st.add_uv(newMsh.uvs[triangle.uv_id_2])
		if hasNrm:
			st.add_normal(newMsh.normals[triangle.nrm_id_2])
		st.add_vertex(newMsh.vertices[triangle.id_2])
	if !hasNrm:
		st.generate_normals()
	if hasUV:
		st.generate_tangents()
	var mdl : Mesh = st.commit()
	
	mdlFile.close()
	return mdl

func count_char(string: String, txt: String) -> int:
	var num : int = 0
	for i in range(0, string.length()):
		if (txt == string[i]):
			num += 1
	return num

#func _magic(input: String) -> int: #Shhhhh, for a future format
#	return ((ord(input[3]) << 24) + (ord(input[2]) << 16) + (ord(input[1]) << 8)) + ord(input[0])

func _import_obj(mdlFile : File) -> TriMesh:
	var newMsh := TriMesh.new()
	while !mdlFile.eof_reached():
		var mdlData := mdlFile.get_line()
		var f2c = mdlData.substr(0, 2)
		var lineData := mdlData.split(" ", false)
		
		match f2c:
			"v ":
				var vertex := Vector3(
					float(lineData[1]),
					float(lineData[2]),
					float(lineData[3])
				)
				newMsh.vertices.push_back(vertex)
			"vt":
				var uv := Vector2(
					float(lineData[1]),
					1.0 - float(lineData[2])
				)
				newMsh.uvs.push_back(uv)
			"vn":
				var normal := Vector3(
					float(lineData[1]),
					float(lineData[2]),
					float(lineData[3])
				)
				newMsh.normals.push_back(normal)
			"f ":
				var misc = []
				
				for i in lineData.size() - 1:
					misc.push_back(lineData[i + 1].split("/"))
				for i in misc.size() - 2:
					var intVar = i + 2
					var num = misc[intVar].size()
					
					var faceIndices = Vector3(
					int(misc[intVar][0]) - 1,
					int(misc[intVar-1][0]) - 1,
					int(misc[0][0]) - 1)
					
					var uvIndices : Vector3
					if num >= 2:
						uvIndices = Vector3(
						int(misc[intVar][1]) - 1,
						int(misc[intVar-1][1]) - 1,
						int(misc[0][1]) - 1)
					
					var normIndices : Vector3
					if num == 3:
						normIndices = Vector3(
						int(misc[intVar][2]) - 1,
						int(misc[intVar-1][2]) - 1,
						int(misc[0][2]) - 1)
					
					var triangle := Triangle.new()
					
					triangle.id_0 = int(faceIndices.x)
					triangle.id_1 = int(faceIndices.y)
					triangle.id_2 = int(faceIndices.z)
					
					triangle.uv_id_0 = int(uvIndices.x)
					triangle.uv_id_1 = int(uvIndices.y)
					triangle.uv_id_2 = int(uvIndices.z)
					
					triangle.nrm_id_0 = int(normIndices.x)
					triangle.nrm_id_1 = int(normIndices.y)
					triangle.nrm_id_2 = int(normIndices.z)
					
					newMsh.indices.push_back(triangle)
	
	return newMsh

class TriMeshModel:
	var meshes : Array
	var materials : Array

class TriMesh:
	var vertices : Array
	var normals : Array
	var uvs : Array
	var indices : Array

class Triangle:
	var id_0 : int
	var uv_id_0 : int
	var nrm_id_0 : int
	var id_1 : int
	var uv_id_1 : int
	var nrm_id_1 : int
	var id_2 : int
	var uv_id_2 : int
	var nrm_id_2 : int
