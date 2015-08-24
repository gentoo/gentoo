# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='xml'

inherit python-single-r1 bash-completion-r1 eutils

DESCRIPTION="Creates a common rpm-metadata repository"
HOMEPAGE="http://createrepo.baseurl.org/"
SRC_URI="http://createrepo.baseurl.org/download/${P}.tar.gz
	https://dev.gentoo.org/~pacho/maintainer-needed/${PN}-0.9.9-head.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/urlgrabber-2.9.0[${PYTHON_USEDEP}]
	>=app-arch/rpm-4.1.1[python,${PYTHON_USEDEP}]
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	>=app-arch/deltarpm-3.6_pre20110223[python,${PYTHON_USEDEP}]
	dev-python/pyliblzma[${PYTHON_USEDEP}]
	>=sys-apps/yum-3.4.3
	${PYTHON_DEPS}"
DEPEND="${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

pkg_setup() {
	python-single-r1_pkg_setup
	python_export PYTHON_SITEDIR
}

src_prepare() {
	epatch "${FILESDIR}/${P}-ten-changelog-limit.patch"
	epatch "${FILESDIR}/${P}-pkglist.patch"
}

src_compile() {
	:
}

src_install() {
	emake install \
		DESTDIR="${ED}" \
		PYTHON=true \
		compdir="$(get_bashcompdir)" \
		PKGDIR="${PYTHON_SITEDIR}/${PN}"
	dodoc ChangeLog README
	python_fix_shebang "${ED}"
	python_optimize
	python_optimize "${ED}/usr/share/createrepo"
}
