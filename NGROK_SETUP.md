# Guide d'installation et configuration de NGROK avec Jenkins

## 📋 Prérequis
- Jenkins installé et fonctionnel sur le port 8080
- Un compte GitHub
- Accès à Internet

---

## 🔧 Étape 1 : Installation de NGROK

### Sur Windows :

1. **Télécharger NGROK**
   - Allez sur https://ngrok.com/download
   - Téléchargez la version Windows
   - Ou utilisez Chocolatey : `choco install ngrok`

2. **Extraire et installer**
   - Extrayez le fichier `ngrok.exe` dans un dossier (ex: `C:\ngrok\`)
   - Ajoutez ce dossier à votre PATH système

3. **Créer un compte NGROK** (gratuit)
   - Allez sur https://dashboard.ngrok.com/signup
   - Créez un compte gratuit
   - Récupérez votre **authtoken** depuis https://dashboard.ngrok.com/get-started/your-authtoken

4. **Configurer votre authtoken**
   ```powershell
   ngrok config add-authtoken VOTRE_AUTHTOKEN_ICI
   ```

### Sur Linux/Mac :

```bash
# Installation via curl
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && sudo apt install ngrok

# Configurer l'authtoken
ngrok config add-authtoken VOTRE_AUTHTOKEN_ICI
```

---

## 🚀 Étape 2 : Exposer Jenkins avec NGROK

1. **Démarrer Jenkins** (s'il n'est pas déjà démarré)
   - Assurez-vous que Jenkins tourne sur le port 8080

2. **Lancer NGROK**
   ```bash
   ngrok http 8080
   ```

3. **Récupérer l'URL publique**
   - NGROK affichera quelque chose comme :
   ```
   Forwarding   https://abc123.ngrok-free.app -> http://localhost:8080
   ```
   - **Copiez l'URL HTTPS** (commence par `https://`)
   - ⚠️ **Note importante** : Cette URL change à chaque redémarrage de NGROK (sauf avec un plan payant)

---

## 🔗 Étape 3 : Configurer le Webhook GitHub

1. **Aller sur votre dépôt GitHub**
   - https://github.com/Kacem-Trabelsi/devops

2. **Accéder aux Settings du dépôt**
   - Cliquez sur **Settings** → **Webhooks** → **Add webhook**

3. **Configurer le Webhook**
   - **Payload URL** : `https://VOTRE-URL-NGROK/github-webhook/`
     - Exemple : `https://abc123.ngrok-free.app/github-webhook/`
   - **Content type** : `application/json`
   - **Secret** : (optionnel, laissez vide pour le test)
   - **Which events** : Sélectionnez "Just the push event"
   - Cliquez sur **Add webhook**

4. **Vérifier le Webhook**
   - GitHub enverra un test (ping)
   - Vérifiez que vous voyez une coche verte ✅

---

## ⚙️ Étape 4 : Configurer Jenkins pour accepter les Webhooks

1. **Installer le plugin GitHub** (si pas déjà installé)
   - Jenkins → **Manage Jenkins** → **Plugins**
   - Recherchez "GitHub plugin" et installez-le

2. **Configurer GitHub dans Jenkins**
   - Jenkins → **Manage Jenkins** → **Configure System**
   - Section **GitHub** :
     - Cliquez sur **Add GitHub Server**
     - **Name** : `GitHub`
     - **API URL** : `https://api.github.com`
     - Cochez **Manage hooks**
     - Cliquez sur **Save**

3. **Configurer le Job Jenkins**
   - Ouvrez votre job Jenkins
   - **Configure** → Section **Build Triggers**
   - Cochez **GitHub hook trigger for GITScm polling**
   - Cliquez sur **Save**

---

## 🧪 Étape 5 : Tester la configuration

1. **Faire un commit et push sur GitHub**
   ```bash
   git add .
   git commit -m "Test webhook"
   git push origin main
   ```

2. **Vérifier dans Jenkins**
   - Le build devrait se déclencher automatiquement
   - Allez dans **Build History** pour voir le nouveau build

---

## 🔄 Étape 6 : Utiliser une URL NGROK permanente (Optionnel)

Pour éviter que l'URL change à chaque redémarrage :

1. **Acheter un domaine NGROK** (plan payant)
   - Ou utiliser un domaine gratuit avec un plan payant

2. **Configurer un domaine statique**
   ```bash
   ngrok http 8080 --domain=votre-domaine.ngrok-free.app
   ```

---

## ⚠️ Notes importantes

- **Sécurité** : L'URL NGROK est publique. Assurez-vous que Jenkins est sécurisé avec des identifiants forts
- **URL temporaire** : L'URL change à chaque redémarrage de NGROK (sauf plan payant)
- **Limites gratuites** : Le plan gratuit a des limites de connexions simultanées
- **Alternative** : Pour la production, utilisez un reverse proxy (Nginx, Apache) avec un domaine fixe

---

## 🐛 Dépannage

### Le webhook ne se déclenche pas
- Vérifiez que NGROK est toujours actif
- Vérifiez l'URL dans GitHub (doit se terminer par `/github-webhook/`)
- Vérifiez les logs Jenkins : **Manage Jenkins** → **System Log**

### Erreur 404
- Assurez-vous que l'URL se termine par `/github-webhook/`
- Vérifiez que le plugin GitHub est installé

### NGROK se ferme
- Gardez la fenêtre NGROK ouverte
- Ou utilisez un service Windows/Linux pour le lancer au démarrage

