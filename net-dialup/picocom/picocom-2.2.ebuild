# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="minimal dumb-terminal emulation program"
HOMEPAGE="https://github.com/npat-efault/picocom"
SRC_URI="https://github.com/npat-efault/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE=""

src_compile() {
	# CPPFLAGS is shared between CFLAGS and CXXFLAGS, but there is no
	# C++ file, and the pre-processor is never called directly, this
	# is easier than patching it out.
	emake LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS} ${CPPFLAGS} -Wall" \
		CC="$(tc-getCC)"
}

src_install() {
	dobin picocom pc{asc,xm,ym,zm}
	doman picocom.1
	dodoc CHANGES.old CONTRIBUTORS README.md
}
