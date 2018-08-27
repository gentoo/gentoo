# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal toolchain-funcs

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="https://sourceware.org/bzip2/"
SUSE_PV="${PV}.0.2"
SUSE_P="${PN}-${SUSE_PV}"
SRC_URI="http://ftp.suse.com/pub/people/sbrabec/bzip2/tarballs/${SUSE_P}.tar.gz"
S="${WORKDIR}/${SUSE_P}"

LICENSE="BZIP2"
SLOT="0/1" # subslot = SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.6-progress.patch
	"${FILESDIR}"/${PN}-1.0.4-POSIX-shell.patch #193365
	"${FILESDIR}"/${PN}-1.0.6-mingw.patch #393573
	"${FILESDIR}"/${PN}-1.0.6-CVE-2016-3189.patch #620466
	"${FILESDIR}"/${PN}-1.0.6-ubsan-error.patch
)

DOCS=( manual.pdf NEWS README.autotools README README.XML.STUFF )
HTML_DOCS=( manual.html )

multilib_src_configure() {
	# use static && append-ldflags -static # doesn't seem to work...
	# fails at gen_usr_ldscript because adding -static to ldflags
	# prevents generation of libbz2.so
	local econfargs=(
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${econfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D%/}" install

	# only make these symlinks on linux as they make no sense on other platforms
	if use kernel_linux; then
		local v
		for v in libbz2.so{,.{${PV%%.*},${PV%.*}}} ; do
			dosym libbz2.so.${PV} /usr/$(get_libdir)/${v}
		done
	fi

	if multilib_is_native_abi ; then
		gen_usr_ldscript -a bz2
	fi
}

multilib_src_install_all() {
	default
	find "${D%/}" -name '*.la' -delete || die
	mkdir -p "${D%/}/bin" || die
	for i in bzip2$(get_exeext) bunzip2$(get_exeext) bzcat$(get_exeext); do
		mv "${D%/}/usr/bin/$i" "${D%/}/bin/" || die
	done
}
