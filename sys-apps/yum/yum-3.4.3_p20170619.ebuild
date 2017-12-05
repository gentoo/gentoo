# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
inherit python-single-r1 systemd

DESCRIPTION="automatic updater and package installer/remover for rpm systems"
HOMEPAGE="http://yum.baseurl.org/"
SRC_URI="https://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~ppc ~x86"

IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/rpm[python,${PYTHON_USEDEP}]
	dev-python/sqlitecachec[${PYTHON_USEDEP}]
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	dev-python/pyliblzma[${PYTHON_USEDEP}]
	dev-python/urlgrabber[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-util/intltool
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

src_prepare() {
	sed -i -e 's/make/$(MAKE)/' Makefile || die
	sed -i -e "s:lib:$(get_libdir):g" rpmUtils/Makefile yum/Makefile || die
	default
}

src_install() {
	emake INIT=systemd UNITDIR="$(systemd_get_systemunitdir)" DESTDIR="${ED}" install
	python_optimize "${D%/}$(python_get_sitedir)" "${ED%/}/usr/share/yum-cli"
	rm -r "${ED%/}/etc/rc.d" || die
	# bug #563850
	python_fix_shebang "${ED}/usr/bin/yum"
}
