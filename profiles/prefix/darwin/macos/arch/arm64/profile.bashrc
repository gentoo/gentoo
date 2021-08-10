# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

pre_src_configure() {
	# catch when multiple pkgs are in one ebuild
	pushd "${WORKDIR}" > /dev/null

	# macOS Big Sur (11.x, darwin20) supports Apple Silicon (arm64),
	# which config.sub currently doesn't understand about.  It is,
	# however, Apple who seem to use arm64-apple-darwin20 CHOST
	# triplets, so patch that for various versions of autoconf
	# This bit should be kept in sync with fix_config_sub in
	# bootstrap-prefix.sh
	if [[ ${CHOST} == arm64-apple-darwin* ]] ; then
		# Apple Silicon doesn't use aarch64, but arm64
		find . -name "config.sub" | \
			xargs sed -i -e 's/ arm\(-\*\)* / arm\1 | arm64\1 /'
		find . -name "config.sub" | \
			xargs sed -i -e 's/ aarch64 / aarch64 | arm64 /'
	fi

	popd > /dev/null
}
