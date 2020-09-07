
using UnityEngine;

public class DissolveAnimation : MonoBehaviour
{
    Material material;
    public float minValue = 1.5f;
    public float maxValue = -0.5f;
    public float durationInSeconds = 4;

    void Start()
    {
        material = GetComponent<MeshRenderer>().material;
        
    }

  
    void Update()
    {
       float value = Mathf.Lerp(minValue, maxValue, Mathf.PingPong(Time.time / durationInSeconds, 1));
        material.SetFloat("_DissolveAmount", value);
    }
}
