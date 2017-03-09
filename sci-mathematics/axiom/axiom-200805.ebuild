# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils multilib flag-o-matic

DESCRIPTION="Axiom is a general purpose Computer Algebra system"
HOMEPAGE="http://axiom.axiom-developer.org/"
SRC_URI="http://www.axiom-developer.org/axiom-website/downloads/${PN}-may2008-src.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# NOTE: Do not strip since this seems to remove some crucial
# runtime paths as well, thereby, breaking axiom
RESTRICT="strip"

DEPEND="virtual/latex-base
	x11-libs/libXaw
	sys-apps/debianutils
	sys-process/procps"
RDEPEND=""

S="${WORKDIR}"/${PN}

pkg_setup() {
	# for 2.6.25 kernels and higher we need to have
	# /proc/sys/kernel/randomize_va_space set to somthing other
	# than 2, otherwise gcl fails to compile (see bug #186926).
	local current_setting=$(/sbin/sysctl kernel.randomize_va_space 2>/dev/null | cut -d' ' -f3)
	if [[ ${current_setting} == 2 ]]; then
		echo
		eerror "Your kernel has brk randomization enabled. This will"
		eerror "cause axiom to fail to compile *and* run (see bug #186926)."
		eerror "You can issue:"
		eerror
		eerror "   /sbin/sysctl -w kernel.randomize_va_space=1"
		eerror
		eerror "as root to turn brk randomization off temporarily."
		eerror "However, when not using axiom you may want to turn"
		eerror "brk randomization back on via"
		eerror
		eerror "   /sbin/sysctl -w kernel.randomize_va_space=2"
		eerror
		eerror "since it results in a less secure kernel."
		die "Kernel brk randomization detected"
	fi
}

src_prepare() {
	cp "${FILESDIR}"/noweb-2.9-insecure-tmp-file.patch.input \
		"${S}"/zips/noweb-2.9-insecure-tmp-file.patch \
		|| die "Failed to fix noweb"
	cp "${FILESDIR}"/${PN}-200711-gcl-configure.patch \
		"${S}"/zips/gcl-2.6.7.configure.in.patch \
		|| die "Failed to fix gcl-2.6.7 configure"
	epatch "${FILESDIR}"/noweb-2.9-insecure-tmp-file.Makefile.patch

	# lots of strict-aliasing badness
	append-flags -fno-strict-aliasing
}

src_compile() {
	# use gcl 2.6.7
	sed -e "s:GCLVERSION=gcl-2.6.8pre$:GCLVERSION=gcl-2.6.7:" \
		-i Makefile.pamphlet Makefile \
		|| die "Failed to select proper gcl"

	# fix libXpm.a location
	sed -e "s:X11R6/lib:$(get_libdir):g" -i Makefile.pamphlet \
		|| die "Failed to fix libXpm lib paths"

	# Let the fun begin...
	AXIOM="${S}"/mnt/linux emake -j1
}

src_install() {
	emake DESTDIR="${D}"/opt/axiom COMMAND="${D}"/opt/axiom/mnt/linux/bin/axiom install

	mv "${D}"/opt/axiom/mnt/linux/* "${D}"/opt/axiom \
		|| die "Failed to mv axiom into its final destination path."
	rm -fr "${D}"/opt/axiom/mnt \
		|| die "Failed to remove old directory."

	dodir /usr/bin
	dosym /opt/axiom/bin/axiom /usr/bin/axiom

	sed -e "2d;3i AXIOM=/opt/axiom" \
		-i "${D}"/opt/axiom/bin/axiom \
		|| die "Failed to patch axiom runscript!"

	dodoc changelog readme faq
}
