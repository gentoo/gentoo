# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit udev

DESCRIPTION="Hardware (PCI, USB, OUI, IAB) IDs databases"
HOMEPAGE="https://github.com/gentoo/hwids"
if [[ ${PV} == "99999999" ]]; then
	PYTHON_COMPAT=( python3_6 )
	inherit git-r3 python-any-r1
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
fi

LICENSE="|| ( GPL-2 BSD ) public-domain"
SLOT="0"
IUSE="+net +pci +udev +usb"

DEPEND=""
RDEPEND="
	udev? ( virtual/udev )
	!<sys-apps/pciutils-3.1.9-r2
	!<sys-apps/usbutils-005-r1
"

if [[ ${PV} == 99999999 ]]; then
	DEPEND+="
		net-misc/curl
		udev? ( $(python_gen_any_dep 'dev-python/pyparsing[${PYTHON_USEDEP}]') )
	"
	python_check_deps() {
		if use udev; then
			has_version --host-root "dev-python/pyparsing[${PYTHON_USEDEP}]"
		fi
	}
else
	S=${WORKDIR}/hwids-${P}
fi

pkg_setup() {
	:
}

src_unpack() {
	if [[ ${PV} == 99999999 ]]; then
		git-r3_src_unpack
		cd "${S}" || die
		emake fetch
	else
		default
	fi
}

src_prepare() {
	default
	sed -i -e '/udevadm hwdb/d' Makefile || die
}

_emake() {
	emake \
		NET=$(usex net) \
		PCI=$(usex pci) \
		UDEV=$(usex udev) \
		USB=$(usex usb) \
		"$@"
}

src_compile() {
	[[ ${PV} == 99999999 ]] && use udev && python_setup
	_emake
}

src_install() {
	_emake install \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		MISCDIR="${EPREFIX}/usr/share/misc" \
		HWDBDIR="${EPREFIX}$(get_udevdir)/hwdb.d" \
		DESTDIR="${D}"
}

pkg_postinst() {
	if use udev; then
		udevadm hwdb --update --root="${ROOT%/}"
	fi
}
