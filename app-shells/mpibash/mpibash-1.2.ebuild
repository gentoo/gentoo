# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils multilib

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://github.com/losalamos/MPI-Bash.git https://github.com/losalamos/MPI-Bash.git"
	inherit git-r3
	KEYWORDS=""
	AUTOTOOLS_AUTORECONF=1
else
	SRC_URI="https://github.com/losalamos/MPI-Bash/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Parallel scripting right from the Bourne-Again Shell (Bash)"
HOMEPAGE="https://github.com/losalamos/MPI-Bash"

LICENSE="GPL-3"
SLOT="0"
IUSE="examples"

DEPEND="virtual/mpi
	>=app-shells/bash-4.2[plugins]
	sys-cluster/libcircle"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--with-bashdir="${EPREFIX}"/usr/include/bash-plugins
		--with-plugindir="${EPREFIX}"/usr/$(get_libdir)/bash
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	sed -i '/^export LD_LIBRARY_PATH/d' "${ED}/usr/bin/${PN}" || die
	use examples || rm -r "${ED}/usr/share/doc/${PF}/examples" || die
}
