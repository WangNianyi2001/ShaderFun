using UnityEngine;

[ExecuteAlways, RequireComponent(typeof(MeshRenderer))]
public class Terrain : MonoBehaviour {
	Shader _heightShader;
	Material _heightMat;
	MeshRenderer _meshRenderer;
	RenderTexture _rt;

	Shader heightShader {
		get {
			if(_heightShader)
				return _heightShader;
			return _heightShader = Shader.Find("ShaderFun/Terrain/Height");
		}
	}
	Material heightMaterial {
		get {
			if(_heightMat == meshRenderer.sharedMaterial && _heightMat?.shader == heightShader)
				return _heightMat;
			return _heightMat = meshRenderer.sharedMaterial = new Material(heightShader);
		}
	}
	MeshRenderer meshRenderer {
		get {
			if(_meshRenderer)
				return _meshRenderer;
			return _meshRenderer = GetComponent<MeshRenderer>();
		}
	}
	RenderTexture rt {
		get {
			if(!heightMap)
				return null;
			if(_rt && _rt.Size() == heightMap.Size())
				return rt;
			if(_rt)
				RenderTexture.ReleaseTemporary(_rt);
			return _rt = Field.Create(heightMap.Size());
		}
	}

	public Texture heightMap;

	void UpdateHeightMap() {
		_rt = Field.Create(heightMap.Size());
		Material convertionMat = new Material(Shader.Find("ShaderFun/Field/FromTexture"));
		convertionMat.mainTexture = heightMap;
		Graphics.Blit(heightMap, _rt, convertionMat);
		heightMaterial.mainTexture = _rt;
	}

	void EditorUpdate() {
		UpdateHeightMap();
	}

	void Start() {
		UpdateHeightMap();
	}

	void Update() {
		if(!Application.isPlaying) {
			EditorUpdate();
			return;
		}
	}

	void OnDestroy() {
		if(_rt)
			RenderTexture.ReleaseTemporary(_rt);
	}
}
