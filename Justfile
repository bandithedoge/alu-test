build:
    librelane src/config.json

show-last:
    librelane --last-run --flow openinopenroad src/config.json

show: build show-last
