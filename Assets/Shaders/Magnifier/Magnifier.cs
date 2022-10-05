using UnityEngine;

[RequireComponent(typeof(Camera))]
public class Magnifier : MonoBehaviour {
	static Shader shader;

	Material material;

	[Range(0f, 300f)] public float radius = 100f;
	[Range(0.1f, 3f)] public float scale = 1.5f;

	void Awake() {
		if(!shader)
			shader = Shader.Find("ShaderFun/Magnifier");
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination) {
		if(!material)
			material = new Material(shader);
		material.SetFloat("_Radius", radius);
		material.SetFloat("_Scale", scale);
		material.SetVector("_Position", Input.mousePosition);
		material.SetVector("_Resolution", new Vector2(Screen.width, Screen.height));
		Graphics.Blit(source, destination, material);
	}
}
