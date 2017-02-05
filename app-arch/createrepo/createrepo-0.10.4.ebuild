# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='xml'

inherit python-single-r1 bash-completion-r1

DESCRIPTION="Creates a common rpm-metadata repository"
HOMEPAGE="http://createrepo.baseurl.org/"
SRC_URI="http://createrepo.baseurl.org/download/${P}.tar.gz"

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

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/${PN}-0.10.3-ten-changelog-limit.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	python_export PYTHON_SITEDIR
}

src_install() {
	emake install \
		DESTDIR="${ED}" \
		PYTHON=true \
		compdir="$(get_bashcompdir)" \
		PKGDIR="${PYTHON_SITEDIR}/${PN}"
	einstalldocs
	python_fix_shebang "${ED}"
	python_optimize
	python_optimize "${ED}/usr/share/createrepo"
}
