using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class Water : MonoBehaviour {
	Material uttMat, displayMat;

	RenderTexture u, ut, utt;

	public Texture initialHeightField;
	public Vector2Int resolution = new Vector2Int(512, 512);

	void Start() {
		uttMat = new Material(Shader.Find("ShaderFun/Water/Utt"));
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
		Graphics.Blit(initialHeightField, u, new Material(Shader.Find("ShaderFun/Field/FromTexture")));
		Field.Zero(ut);
		Field.Zero(utt);
	}

	void OnDestroy() {
		RenderTexture.ReleaseTemporary(u);
		RenderTexture.ReleaseTemporary(ut);
		RenderTexture.ReleaseTemporary(utt);
	}

	void FixedUpdate() {
		uttMat.mainTexture = u;
		Graphics.Blit(null, utt, uttMat);

		Field.Plus(utt, ut, ut);
		Field.Scale(ut, 0.999f, ut);
		Field.Plus(ut, u, u);
	}
}
