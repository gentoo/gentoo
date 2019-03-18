# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="coffeescript"

DESCRIPTION="A little language that compiles into javascript"
HOMEPAGE="https://coffeescript.org/"
SRC_URI="https://github.com/jashkenas/${MY_PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# This package has a test suite (that works), but it requires a number
# of NodeJS/NPM packages that aren't in the tree.
IUSE="doc examples"

RDEPEND="net-libs/nodejs"

src_install(){
	local npm_module_dir="/usr/$(get_libdir)/node/${PN}"
	insinto "${npm_module_dir}"
	doins *.js package.json
	doins -r lib
	dodoc CONTRIBUTING.md README.md

	if use examples; then
		# Users should be able to run the examples without having to copy
		# them to another directory and decompress them.
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r documentation/examples
	fi

	if use doc; then
		# It looks like "docs/v2" contains the output from all of the stuff
		# under "documentation".
		docinto "html"
		dodoc -r docs/v2/*
	fi

	# The coffee and cake "binaries" use a relative path to find the lib
	# directory, so we have to symlink them rather than use dobin().
	exeinto "${npm_module_dir}/bin"
	doexe bin/cake
	doexe bin/coffee
	dosym "${npm_module_dir}/bin/cake" "/usr/bin/cake"
	dosym "${npm_module_dir}/bin/coffee" "/usr/bin/coffee"
}
