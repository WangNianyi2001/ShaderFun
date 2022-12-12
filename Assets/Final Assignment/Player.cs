using UnityEngine;
using UnityEngine.InputSystem;

[RequireComponent(typeof(CharacterController))]
public class Player : MonoBehaviour {
	public Transform cameraTransform;
	public float movingSpeed;
	public float orientingSpeed;
	public InputAction move;
	public InputAction orient;

	CharacterController controller;
	Vector3 velocity;
	Vector2 orientation;

	public void Move(InputAction.CallbackContext cb) {
		var xy = cb.ReadValue<Vector2>();
		velocity = new Vector3(xy.x, 0, xy.y) * movingSpeed;
	}
	public void Orient(InputAction.CallbackContext cb) {
		orientation += cb.ReadValue<Vector2>() * orientingSpeed;
		orientation.y = Mathf.Min(orientation.y, 90);
		orientation.y = Mathf.Max(orientation.y, -90);
		transform.localRotation = Quaternion.Euler(new Vector3(0, orientation.x, 0));
		cameraTransform.localRotation = Quaternion.Euler(new Vector3(-orientation.y, 0, 0));
	}

	void Start() {
		controller = GetComponent<CharacterController>();
		Cursor.lockState = CursorLockMode.Locked;

		move.Enable();
		move.performed += Move;
		move.canceled += (InputAction.CallbackContext _) => velocity = Vector3.zero;
		orient.Enable();
		orient.performed += Orient;
	}

	void Update() {
		controller.SimpleMove(transform.localToWorldMatrix.MultiplyVector(velocity));
	}
}
