# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit fdo-mime python-single-r1

DESCRIPTION="A graphical tool to compare and merge text files"
HOMEPAGE="http://diffuse.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-solaris"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pygtk[${PYTHON_MULTI_USEDEP}]
	')"
# file collision, bug #279018
DEPEND="${DEPEND}
	!sci-chemistry/tinker"

src_prepare() {
	local i p

	# linguas handling wrt #406433
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(for p in translations/*.po ; do echo ${p%.po} ; done) ; do
			if ! has ${i##*/} ${LINGUAS} ; then
				rm "${S}"/${i}.po || die
			fi
		done
	fi

	python_fix_shebang src/usr/bin/diffuse
}

src_install() {
	"${PYTHON}" install.py \
		--prefix="${EPREFIX}"/usr \
		--sysconfdir="${EPREFIX}"/etc \
		--files-only \
		--destdir="${D}" \
		|| die "Installation failed"
	dodoc AUTHORS ChangeLog README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
