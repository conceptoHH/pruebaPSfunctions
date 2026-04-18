oh-my-posh init pwsh --config "C:/Users/PC/Desktop/my-config-omp.json" | Invoke-Expression
function glo {
    git log  --oneline --decorate --graph --parents .
}

function gs {
    git status .
}

function ga {
    git add .
}

function gic($msg) {
   git commit -m "$msg"
}

function gip ($remote, $branch) {    
    git push -u $remote $branch
}

function gpl ($remote, $branch) {
    git pull $remote $branch
}

function notes {
    Push-Location C:\Users\PC\Documents\notas
    code .
}

function maki {
    Push-Location C:\Users\PC\REPOSITORIOS\makiavelo_bot_disc\dc_bot_maki
    .\Scripts\Activate.ps1
    python .\main.py
}
