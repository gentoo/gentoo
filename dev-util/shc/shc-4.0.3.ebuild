# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A (shell-) script compiler/scrambler"
HOMEPAGE="
	https://github.com/neurobin/shc
	https://neurobin.org/projects/softwares/unix/shc/
"
SRC_URI="https://github.com/neurobin/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

IUSE="test"

DEPEND="test? (
	app-shells/bash:0
	app-shells/dash
	app-shells/ksh
	app-shells/tcsh
	app-shells/zsh
)"
RDEPEND=""

RESTRICT="!test? ( test )"

src_prepare() {
	# ash requires sys-apps/busybox[make-symlinks], so exclude it too
	# Exclude app-shells/rc from tests
	# Fix path for app-shells/tcsh
	sed -i \
		-e "s:'/bin/ash'::" \
		-e "s:'/usr/bin/rc'::" \
		-e "s:/usr/bin/tcsh:/bin/tcsh:" \
		test/ttest.sh || die

	default
}

src_install() {
	dobin src/shc
	doman shc.1
	dodoc ChangeLog README.md
}
