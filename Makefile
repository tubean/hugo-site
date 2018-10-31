
# init project
init:
	@git fetch \
		&& git submodule update --init \
		&& git worktree add public -b master \
		&& cd public \
		&& git branch --set-upstream-to=origin/master master \
		&& cd ..

# for build code
bcode:
	@cd code \
		&& source .venv/bin/activate \
		&& jupyter notebook

# for dev
dev:
	@open /Applications/Google\ Chrome.app 'http://localhost:1313' \
		| hugo server -D

# build
# minify output https://github.com/tdewolff/minify/tree/master/cmd/minify#directories
build:
	@hugo -d tmp_public \
		&& rm -rf public/* \
		&& cp -R tmp_public/* public \
		&& minify -v -r --html-keep-document-tags --html-keep-end-tags -o public/ tmp_public \
		&& rm -rf tmp_public

# for publish
deploy:
	cd public \
		&& git add --all \
		&& git commit -m "Build on $$(date)" \
		&& git push \
		&& cd ..

# for dev branch
draft:
	@git add --all \
		&& git commit -m "Build on $$(date)" \
		&& git push \

# publish & push
push:
	@make draft \
		&& make build \
		&& make deploy

# ensure publish
ok:
	@read -p 'Slug and Draft is OK (y/n)? ' yes; \
		if [ $$yes = 'y' ]; then make push; fi;

# pull
pull:
	@git pull \
		&& cd public \
		&& git pull \
		&& cd ..

# add publish page
set-publish:
	@rm -rf public && mkdir public \
		&& git worktree prune \
		&& rm -rf .git/worktrees/public/ \
		&& git worktree add -B master public origin/master \
&& rm -rf public/*
