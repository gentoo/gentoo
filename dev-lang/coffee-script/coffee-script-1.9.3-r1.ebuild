# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/coffee-script/coffee-script-1.9.3-r1.ebuild,v 1.1 2015/07/10 14:44:19 mjo Exp $

EAPI=5

inherit multilib

MY_PN="coffeescript"

DESCRIPTION="A little language that compiles into javascript"
HOMEPAGE="http://coffeescript.org/"

# The tests are missing from the npm registry package, so use Github
# instead.
SRC_URI="https://github.com/jashkenas/${MY_PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# This package has a test suite (that works), but it requires a number
# of packages not in the tree. See thread "NPM / NodeJS project" on the
# gentoo-dev archives for more info.
IUSE="doc examples"

RDEPEND="net-libs/nodejs"

src_install(){
	local npm_module_dir="/usr/$(get_libdir)/node/${PN}"
	insinto "${npm_module_dir}"
	doins *.js package.json
	doins -r lib
	dodoc CONTRIBUTING.md README.md

	use doc && dodoc -r documentation
	use examples && dodoc -r examples

	# The coffee and cake "binaries" use a relative path to find the lib
	# directory, so we have to symlink them rather than use dobin().
	exeinto "${npm_module_dir}/bin"
	doexe bin/cake
	doexe bin/coffee
	dosym "${npm_module_dir}/bin/cake" "/usr/bin/cake"
	dosym "${npm_module_dir}/bin/coffee" "/usr/bin/coffee"
}
