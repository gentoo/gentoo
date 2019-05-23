# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Intel CPU undervolting and throttling configuration tool"
HOMEPAGE="https://github.com/kitsunyan/intel-undervolt"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kitsunyan/${PN}.git"
else
	SRC_URI="https://github.com/kitsunyan/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND=""

CONFIG_CHECK="~INTEL_RAPL ~X86_MSR"

src_prepare() {
	# respect CC, CFLAGS and avoid calling pkg-config
	sed -i \
		-e 's/^CC=/CC?=/' \
		-e 's/^CFLAGS=/CFLAGS?=/' \
		-e '/^UNITDIR=/d' \
		Makefile || die

	default
}

src_compile() {

	tc-export CC

	myemakeargs=(
		BINDIR="${EPREFIX}"/usr/bin
		SYSCONFDIR="${EPREFIX}"/etc
		UNITDIR="$(systemd_get_systemunitdir)"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	myemakeargs+=(
		DESTDIR="${D}"
	)
	emake "${myemakeargs[@]}" install

	newinitd "${FILESDIR}"/initd "${PN}"
	newconfd "${FILESDIR}"/confd "${PN}"

	einstalldocs
}
