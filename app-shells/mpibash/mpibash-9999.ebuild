# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/lanl/MPI-Bash.git"
	inherit git-r3
else
	SRC_URI="https://github.com/lanl/MPI-Bash/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Parallel scripting right from the Bourne-Again Shell (Bash)"
HOMEPAGE="https://github.com/lanl/MPI-Bash"

LICENSE="GPL-3"
SLOT="0"
IUSE="examples"

DEPEND="virtual/mpi
	>=app-shells/bash-4.2:0[plugins]
	sys-cluster/libcircle"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	[[ ${PV} != 9999 ]] || eautoreconf
}

src_configure() {
	econf --with-plugindir="${EPREFIX}"/usr/$(get_libdir)/bash \
		--with-bashdir="${EPREFIX}"/usr/include/bash-plugins
}

src_install() {
	default
	sed -i '/^export LD_LIBRARY_PATH/d' "${ED}/usr/bin/${PN}" || die
	use examples || rm -r "${ED}/usr/share/doc/${PF}/examples" || die
}
