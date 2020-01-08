# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

COMMIT=45ec81c185789b2dbafd7348d1af039b5183c9ff
inherit python-single-r1 gnome2-utils vcs-snapshot

DESCRIPTION="Backup system inspired by TimeVault and FlyBack"
HOMEPAGE="https://backintime.readthedocs.io/ https://github.com/bit-team/backintime/"
SRC_URI="https://github.com/bit-team/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="qt5"

DEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	net-misc/openssh
	net-misc/rsync[xattr,acl]"
RDEPEND="${DEPEND}
	qt5? ( dev-python/PyQt5 )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	#fix doc install location
	sed -e "s:/doc/${PN}-common:/doc/${PF}:g" \
		-i common/configure || die
	sed -e "s:/doc/${PN}-qt:/doc/${PF}:g" \
		-i qt/configure || die
	sed -e "/addInstallFile \"..\/VERSION/d" \
		-e "/addInstallFile \"..\/LICENSE/d" \
		-e "/addInstallFile \"..\/debian\/copyright/d" \
		-i {qt,common}/configure || die

	if [ -n ${LINGUAS+x} ] ; then
		cd common/po || die
		for po in *.po ; do
			if ! has ${po/.po} ${LINGUAS} ; then
				rm ${po} || die
			fi
		done
	fi

	default
}

src_configure() {
	cd "${S}"/common || die
	./configure --python3 --no-fuse-group || die
	if use qt5 ; then
		cd "${S}"/qt || die
		./configure --python3 || die
	fi
}

src_compile() {
	cd "${S}"/common || die
	emake
	if use qt5 ; then
		cd "${S}"/qt || die
		emake
	fi
}

src_install() {
	cd "${S}"/common || die
	emake DESTDIR="${D}" install
	if use qt5 ; then
		cd "${S}"/qt || die
		emake DESTDIR="${D}" install
	fi

	python_optimize "${D}"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
