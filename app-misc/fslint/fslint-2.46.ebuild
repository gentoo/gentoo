# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

# The eutils eclass is still needed for doicon() and domenu().
inherit eutils python-r1

DESCRIPTION="A utility to find various forms of lint on a filesystem"
HOMEPAGE="http://www.pixelbeat.org/fslint/"
SRC_URI="${HOMEPAGE}${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	gnome-base/libglade:2.0"

DEPEND="nls? ( sys-devel/gettext:* )"

src_prepare() {
	default

	# Change some paths to make ${PN}-gui run with our filesystem layout.
	# These commands are taken from the debian/rules file.
	sed -e "s:^liblocation=.*$:liblocation='${EROOT}usr/share/${PN}':" \
		-e "s:^locale_base=.*$:locale_base=None:" \
		-i "${PN}-gui" \
		|| die "failed to fix liblocation and locale_base in ${PN}-gui"
}

src_install() {
	# The commands below roughly follow debian/rules.
	python_foreach_impl python_doscript "${PN}-gui"

	insinto "/usr/share/${PN}"
	doins "${PN}.glade" "${PN}_icon.png"

	exeinto "/usr/share/${PN}/${PN}"
	doexe "${PN}"/find*
	doexe "${PN}/${PN}"
	doexe "${PN}/zipdir"

	exeinto "/usr/share/${PN}/${PN}/fstool"
	doexe "${PN}/fstool/dir_size" "${PN}/fstool/edu" "${PN}/fstool/lS"
	python_scriptinto "/usr/share/${PN}/${PN}/fstool"
	python_foreach_impl python_doscript "${PN}/fstool/dupwaste"

	exeinto "/usr/share/${PN}/${PN}/supprt"
	doexe "${PN}"/supprt/get*

	python_scriptinto "/usr/share/${PN}/${PN}/supprt"
	python_foreach_impl python_doscript "${PN}/supprt/md5sum_approx"

	doexe "${PN}/supprt/fslver"

	exeinto "/usr/share/${PN}/${PN}/supprt/rmlint"
	doexe "${PN}"/supprt/rmlint/*.sh
	python_scriptinto "/usr/share/${PN}/${PN}/supprt/rmlint"
	python_foreach_impl python_doscript "${PN}/supprt/rmlint/fixdup"
	python_foreach_impl python_doscript "${PN}/supprt/rmlint/merge_hardlinks"

	doicon "${PN}_icon.png"
	domenu "${PN}.desktop"

	dodoc doc/{FAQ,NEWS,README,TODO}
	doman man/*.1

	if use nls; then
		cd po || die
		emake DESTDIR="${D}" install
	fi
}
