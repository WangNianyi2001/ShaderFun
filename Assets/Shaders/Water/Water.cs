using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class Water : MonoBehaviour {
	public Material uttMat, displayMat;

	public RenderTexture u, ut, utt;

	public Texture initialHeightField;
	public Vector2Int resolution = new Vector2Int(512, 512);
	public Terrain terrain;

	[Range(0, 3)]
	public float simulationSpeed = 1f;
	[Range(0, 10)]
	public float zeroOrderCoefficient = 10f;
	[Range(1, 100)]
	public float firstOrderCoefficient = 4f;
	[Range(.8f, 1f)]
	public float firstOrderAttenuation = .85f;
	[Range(0, 1)]
	public float secondOrderCoefficient = .1f;

	void Awake() {
		Application.targetFrameRate = 30;
	}

	void Start() {
		uttMat = new Material(Shader.Find("ShaderFun/Water/Acceleration"));
		uttMat.SetTexture("TerrainHeight", terrain?.heightMap);
		displayMat = new Material(Shader.Find("ShaderFun/Water/Display"));

		u = Field.Create(resolution);
		ut = Field.Create(resolution);
		utt = Field.Create(resolution);

		displayMat.SetTexture("Height", u);
		displayMat.SetTexture("Laplace", utt);
		GetComponent<MeshRenderer>().material = displayMat;

		Reset();
	}

	public void Reset() {
		Field.Zero(utt);
		Field.Zero(ut);
		Field.Zero(u);
		Graphics.Blit(initialHeightField, u, new Material(Shader.Find("ShaderFun/Field/FromTexture")));
	}

	void OnDestroy() {
		RenderTexture.ReleaseTemporary(u);
		RenderTexture.ReleaseTemporary(ut);
		RenderTexture.ReleaseTemporary(utt);
	}

	void Update() {
		uttMat.mainTexture = u;
		uttMat.SetFloat("ca", zeroOrderCoefficient);
		Graphics.Blit(null, utt, uttMat);

		float dt = Time.deltaTime * simulationSpeed;

		Field.Plus(ut, utt, firstOrderCoefficient * dt, ut);
		Field.Scale(ut, firstOrderAttenuation, ut);
		Field.Plus(u, ut, secondOrderCoefficient * dt, u);
	}
}
