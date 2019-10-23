# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="git@github.com:haubi/parity.git https://github.com/haubi/parity.git"
	DEPEND="dev-util/confix"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS=""
fi
DESCRIPTION="A POSIX to native Win32 Cross-Compiler Tool (requires Visual Studio)"
HOMEPAGE="https://github.com/haubi/parity"

parity-vcarchs() { echo x64 x86 ; }
parity-vcvers-legacy() { echo 7_0 7_1 8_0 9_0 ; }
parity-vcvers-current() { echo 10_0 11_0 12_0 14_0 15 16 ; }
parity-vcvers() {
	parity-vcvers-legacy
	parity-vcvers-current
}

LICENSE="LGPL-3"
SLOT="0"
IUSE="$(
	for a in $(parity-vcarchs); do echo "+vc_${a}"; done
	for v in $(parity-vcvers-legacy); do echo "vc${v}"; done
	for v in $(parity-vcvers-current); do echo "+vc${v}"; done
)"

if [[ ${PV} == 9999 ]]; then
	src_prepare() {
		default
		confix --output || die
		eautoreconf
	}
fi

parity-enabled-vcarchs() {
	local enabled= a
	for a in $(parity-vcarchs) ; do
		if use vc_${a} ; then
			enabled+=",${a}"
		fi
	done
	echo ${enabled#,}
}

parity-enabled-vcvers() {
	local enabled= v
	for v in $(parity-vcvers) ; do
		if use vc${v} ; then
			enabled+=",${v/_/.}"
		fi
	done
	echo ${enabled#,}
}

src_configure() {
	local myconf=(
		--enable-msvc-archs="$(parity-enabled-vcarchs)"
		--enable-msvc-versions="$(parity-enabled-vcvers)"
		--disable-default-msvc-version
	)
	econf "${myconf[@]}"
}

pkg_postinst() {
	if [[ -n ${ROOT%/} ]] ; then
		einfo "To enable all available MSVC versions, on the target machine please run:"
		einfo " '${EPREFIX}/usr/bin/parity-setup' --enable-all"
	else
		"${EPREFIX}"/usr/bin/parity-setup --enable-all
	fi
}
