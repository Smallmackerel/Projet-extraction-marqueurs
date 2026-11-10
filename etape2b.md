### 1. Formalisation théorique du filtre (Pour ton rapport / oral)

L'opération qui consiste à faire la moyenne des $N$ derniers échantillons s'écrit mathématiquement :


$$tendance(n) = \frac{1}{N} \sum_{k=0}^{N-1} y(n-k)$$

Les caractéristiques de ce filtre sont les suivantes :

* **Type (RIF / RII) :** C'est un filtre à **Réponse Impulsionnelle Finie (RIF)** (ou FIR en anglais). Sa réponse impulsionnelle $h(n)$ a une durée finie de $N$ échantillons :

$$h(n) = \begin{cases} \frac{1}{N} & \text{pour } 0 \le n \le N-1 \\ 0 & \text{sinon} \end{cases}$$


* **Causalité :** Le filtre utilise uniquement des échantillons passés et présent ($y(n), y(n-1), \dots, y(n-N+1)$). Il est donc **causal**.
* **Stabilité :** C'est un filtre RIF à coefficients finis, il est donc **toujours strictement stable** (tous ses pôle(s) sont à l'origine $z=0$).
* **Réponse en fréquence :** Sa fonction de transfert $H(z)$ et sa réponse en fréquence $H(e^{j\omega})$ s'écrivent :

$$H(e^{j\omega}) = \frac{1}{N} \frac{1 - e^{-j\omega N}}{1 - e^{-j\omega}} = e^{-j \omega \frac{N-1}{2}} \cdot \frac{\sin(\omega N / 2)}{N \sin(\omega / 2)}$$



C'est le filtre cardinal en sinus cardinal ($\text{sinc}$), typique d'une moyenne glissante passe-bas.
* **Phase linéaire et Retard :** La réponse en fréquence possède un terme de phase purement linéaire $e^{-j \omega \frac{N-1}{2}}$. Le filtre introduit donc un **retard de groupe constant** égal à :

$$\tau = \frac{N-1}{2} \text{ échantillons}$$


* **Minimum de phase :** Non, ce n'est pas un filtre à minimum de phase car ses zéros sont répartis sur le cercle unité (les fréquences $f_k = k/N$).

---
