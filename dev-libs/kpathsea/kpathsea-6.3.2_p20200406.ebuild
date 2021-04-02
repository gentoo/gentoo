# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit texlive-common libtool prefix tmpfiles

TEXMFD_VERSION="10"

DESCRIPTION="Path searching library for TeX-related files"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI="https://dev.gentoo.org/~zlogene/distfiles/texlive/texlive-${PV#*_p}-source.tar.xz
	https://dev.gentoo.org/~zlogene/distfiles/texlive/${PN}-texmf.d-${TEXMFD_VERSION}.tar.xz"

LICENSE="GPL-2"
SLOT="0/${PV%_p*}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc source static-libs"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/${PN}

TL_VERSION=2020
EXTRA_TL_MODULES="kpathsea"
EXTRA_TL_DOC_MODULES="kpathsea.doc"

for i in ${EXTRA_TL_MODULES} ; do
	SRC_URI="${SRC_URI} https://dev.gentoo.org/~zlogene/distfiles/texlive/tl-${i}-${TL_VERSION}.tar.xz"
done

SRC_URI="${SRC_URI} doc? ( "
for i in ${EXTRA_TL_DOC_MODULES} ; do
	SRC_URI="${SRC_URI} https://dev.gentoo.org/~zlogene/distfiles/texlive/tl-${i}-${TL_VERSION}.tar.xz"
done
SRC_URI="${SRC_URI} ) "

TEXMF_PATH=/usr/share/texmf-dist

src_prepare() {
	default
	cd "${WORKDIR}/texlive-${PV#*_p}-source" || die
	S="${WORKDIR}/texlive-${PV#*_p}-source" elibtoolize
	cp "${FILESDIR}/texmf-update-r2" "${S}"/texmf-update || die
	eprefixify "${S}"/texmf-update
}

src_configure() {
	# Too many regexps use A-Z a-z constructs, what causes problems with locales
	# that don't have the same alphabetical order than ascii. Bug #347798
	# So we set LC_ALL to C in order to avoid problems.
	export LC_ALL=C

	# Disable largefile because it seems to cause problems on big endian 32 bits
	# systems...
	econf \
		--disable-largefile \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" web2cdir="${EPREFIX}/usr/share/texmf-dist/web2c" install
	find "${D}" -name '*.la' -delete || die

	dodir /usr/share # just in case
	cp -pR "${WORKDIR}"/texmf-dist "${ED}/usr/share/" || die "failed to install texmf trees"
	if use source ; then
		cp -pR "${WORKDIR}"/tlpkg "${ED}/usr/share/" || die "failed to install tlpkg files"
	fi

	# The default configuration expects it to be world writable, bug #266680
	# People can still change it with texconfig though.
	dotmpfiles "${FILESDIR}"/kpathsea.conf

	# Take care of fmtutil.cnf and texmf.cnf
	dodir /etc/texmf/{fmtutil.d,texmf.d}

	# Remove default texmf.cnf to ship our own, greatly based on texlive dvd's
	# texmf.cnf
	# It will also be generated from /etc/texmf/texmf.d files by texmf-update
	rm -f "${ED}${TEXMF_PATH}/web2c/texmf.cnf"

	insinto /etc/texmf/texmf.d
	doins "${WORKDIR}/texmf.d/"*.cnf

	# Remove fmtutil.cnf, it will be regenerated from /etc/texmf/fmtutil.d files
	# by texmf-update
	rm -f "${ED}${TEXMF_PATH}/web2c/fmtutil.cnf"

	dosym ../../../../etc/texmf/web2c/fmtutil.cnf ${TEXMF_PATH}/web2c/fmtutil.cnf
	dosym ../../../../etc/texmf/web2c/texmf.cnf ${TEXMF_PATH}/web2c/texmf.cnf

	newsbin "${S}/texmf-update" texmf-update

	# Keep it as that's where the formats will go
	keepdir /var/lib/texmf

	dodoc ChangeLog NEWS PROJECTS README
}

pkg_postinst() {
	tmpfiles_process "${FILESDIR}"/kpathsea.conf

	etexmf-update
}

pkg_postrm() {
	etexmf-update
}
