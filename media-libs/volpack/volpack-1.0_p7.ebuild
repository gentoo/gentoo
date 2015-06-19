# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/volpack/volpack-1.0_p7.ebuild,v 1.4 2012/04/12 23:07:37 bicatali Exp $

EAPI=4

MYP=${PN}-${PV/_p/c}

DESCRIPTION="Volume rendering library"
HOMEPAGE="http://amide.sourceforge.net/packages.html"
SRC_URI="mirror://sourceforge/amide/${MYP}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/m4"

S="${WORKDIR}/${MYP}"

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	emake -j1
}

src_install() {
	default
	use doc && dodoc doc/*.pdf && dohtml doc/*.html
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

}
