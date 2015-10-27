# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator vcs-snapshot

SLOT="0"

DESCRIPTION="smart code editor PHP, HTML, JavaScript, CSS, Sass, Less, CoffeeScript, and many other languages."
HOMEPAGE="http://www.jetbrains.com/phpstorm"
SRC_URI="http://download.jetbrains.com/webide/PhpStorm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PhpStorm
	|| ( PhpStorm_Academic PhpStorm_Classroom PhpStorm_OpenSource PhpStorm_personal )"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.7:*"

src_unpack() {
	vcs-snapshot_src_unpack
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r .
	fperms 755 ${dir}/bin/{${PN}.sh,fsnotifier{,64}}

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
}
