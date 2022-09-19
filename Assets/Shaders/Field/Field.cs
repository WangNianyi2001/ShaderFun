using UnityEngine;

public static class Field {
	public static RenderTexture Create(Vector2Int res) {
		if(!zeroTex)
			zeroTex = Resources.Load<Texture>("zero");
		return RenderTexture.GetTemporary(res.x, res.y);
	}

	static Texture zeroTex;
	public static void Zero(RenderTexture field) {
		Graphics.Blit(zeroTex, field);
	}

	static Material plusMat;
	public static void Plus(Texture a, Texture b, RenderTexture output) {
		if(!plusMat)
			plusMat = new Material(Shader.Find("ShaderFun/Field/Plus"));
		plusMat.SetTexture("A", a);
		plusMat.SetTexture("B", b);
		if(output == a || output == b) {
			RenderTexture temp = RenderTexture.GetTemporary(output.width, output.height);
			Graphics.Blit(null, temp, plusMat);
			Graphics.Blit(temp, output);
			RenderTexture.ReleaseTemporary(temp);
		}
		else
			Graphics.Blit(null, output, plusMat);
	}

	static Material scaleMat;
	public static void Scale(Texture field, float scalar, RenderTexture output) {
		if(!scaleMat)
			scaleMat = new Material(Shader.Find("ShaderFun/Field/Scale"));
		scaleMat.SetTexture("Field", field);
		scaleMat.SetFloat("Scalar", scalar);
		if(output == field) {
			RenderTexture temp = RenderTexture.GetTemporary(output.width, output.height);
			Graphics.Blit(null, temp, scaleMat);
			Graphics.Blit(temp, output);
			RenderTexture.ReleaseTemporary(temp);
		}
		else
			Graphics.Blit(null, output, scaleMat);
	}
}