# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 bash-completion-r1

DESCRIPTION="Automated Packages Builder for Portage and Entropy"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+entropy"
SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/${PN}"

DEPEND=""
RDEPEND="entropy? ( ~sys-apps/entropy-${PV}[${PYTHON_USEDEP}] )
	sys-apps/file[python]
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	emake DESTDIR="${D}" base-install || die "make base-install failed"
	if use entropy; then
		emake DESTDIR="${D}" entropysrv-install || die "make base-install failed"
	fi

	python_optimize "${D}/usr/lib/matter"
}
