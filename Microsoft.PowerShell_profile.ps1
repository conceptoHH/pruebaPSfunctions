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

function notes {
    Push-Location C:\Users\PC\Documents\notas
    code .
}