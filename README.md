# PhD Thesis Nicolas Morell Dameto

<a name="readme-top"></a>



[![LinkedIn][linkedin-shield]][linkedin-url]




<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://www.comillas.edu/">
    <img src="https://i0.wp.com/creatividadenblanco.com/wp-content/uploads/2018/06/AAFF_LOG_COMPLETO_COMILLAS_COLOR_POSITIVO_RGB.png?ssl=1)" alt="Logo" width="300" height="200">
  </a>

  <h3 align="center">Distribution network tariff design under decarbonization, decentralization, and digitalization</h3>

  <p align="center">
    The digital repository of the PhD thesis
    <br />
    <a href="https://github.com/Nmorelldam/PhD-Thesis-Nicolas-Morell-Dameto"><strong>Explore the docs »</strong></a>
    <br />
    <br />
  </p>
  <a href="https://www.iit.comillas.edu/">
    <img src="https://www.iit.comillas.edu/resources/images/global/logoIIT.gif" alt="Logo" width="100" height="100">
  </a>
</div>


<!-- ABSTRACT -->
## Abstract

The electricity network tariffs aim to recover network costs while also adhering to principles of economic efficiency and equity. The majority of existing network tariffs in different countries primarily focus on cost recovery, implicitly assuming customers are not very sensitive to price changes. Despite theoretical proposals for network tariff designs that align better with these principles, their validation is confined to simplified network systems. This thesis formulates a dynamic network tariff with high temporal and geographical granularity and implements it in a real electricity system. The implementation into the actual system is achieved by adapting tariff methodologies to manage large-scale multi-layered networks and complex datasets.

Due to most network costs are sunk costs, the enhanced tariff design focuses on signalling long-term network costs, those that network operators are likely to incur in a future where demand continues to grow, i.e., those that can be reduced or even avoided. On the other hand, long-term costs are usually smaller than sunk costs, hence an additional term, called residual costs, needs to be paid by consumers to achieve the cost recovery objective.

In the context of the entire network, consumers and generators need to be grouped into subsystems based on voltage levels. This grouping allows for the calculation of network utilization levels, a framework known as the cascade model. While long-term costs are recovered through energy charges during peak network utilization hours, which are symmetric for both energy injections and withdrawals, residual costs are recovered through a fixed charge without distorting other economic signals.

This innovative network tariff structure encourages the shifting of flexible loads to periods of lower demand, aligning the economic incentives for individual users with system benefits. As a result, this approach reduces the need for future network investments. Furthermore, the equitable nature of the proposed tariff establishes a level-playing field for distributed resources that offer flexibility services. Illustrated through the example of Slovenia, this thesis provides a framework worthy of consideration by regulators for implementation in real-world electricity systems.

Additionally, this thesis examines the performance of different long-term network tariff designs in a future with many flexible customers who respond to price signals by modifying their consumption patterns. In theory, long-term economic signals balance between flexible consumption and the long-term costs associated with network expansion. Designs of long-term network tariffs with high geographical granularity are studied, which improves the efficiency of cost distribution among users. However, it is observed that when a significant number of users synchronize their responses to ex-ante network charges, the peak-shifting effect occurs, leading to new network peaks that trigger network reinforcements earlier than initially expected.

Thus, this thesis demonstrates that the predictability principle, often associated with fairness, could conflict with the principle of economic efficiency in this context. As a solution, ex-post pricing aligns network charges with the gradual growth of network costs over time. To address the lower predictability for users, this thesis proposes an innovative coordination mechanism for user response. This mechanism involves a local network capacity market where users reserve their expected network capacity usage within a competitive framework. A detailed case study is presented, comparing various network tariffs in this context, showing that the application of ex-post tariffs and the proposed mechanism can prevent greater network reinforcements by coordinating user responses. The complexity of the presented tariff structure places retailers and aggregators as key players in the future electricity system, acting as intermediaries to transform complex tariff structures into products tailored to each user's flexibility and risk tolerance.



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/nicolasmorelldameto/
