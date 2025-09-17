document.addEventListener('DOMContentLoaded', ()=>{
  const projects = [
    {"name":"CI/CD Pipeline","description":"Automated pipelines using Jenkins and GitHub Actions with Docker and Kubernetes.","tech":"Jenkins, Docker, K8s, AWS"},
    {"name":"Monitoring & Observability","description":"Prometheus, Grafana and ELK stack for centralized metrics & logs.","tech":"Prometheus, Grafana, ELK"}
  ];
  const list = document.getElementById('project-list');
  if(!list) return;
  projects.forEach(p=>{
    const card=document.createElement('div');
    card.className='project-card';
    card.innerHTML = `<h3>${p.name}</h3><p style="color:var(--muted)">${p.description}</p><p style="color:var(--muted)"><strong>Tech:</strong> ${p.tech}</p>`;
    list.appendChild(card);
  });
});