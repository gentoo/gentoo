# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 bash-completion-r1

DESCRIPTION="Entropy Package Manager text-based client"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}"

COMMON_DEPEND="${PYTHON_DEPS}
	~sys-apps/entropy-${PV}[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc"
RDEPEND="${COMMON_DEPEND}
	sys-apps/file[python]"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_compile() {
	cd "${S}"/client || die
	emake
}

src_install() {
	cd "${S}"/client || die
	emake DESTDIR="${D}" LIBDIR="usr/lib" install
	newbashcomp "${S}/misc/equo-completion.bash" equo

	python_optimize "${D}/usr/lib/entropy/client"
}
