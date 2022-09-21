# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: please bump this together with mail-mta/sendmail

inherit toolchain-funcs

# This library is part of sendmail, but it does not share the version number with it.
# In order to find the right libmilter version number, check SMFI_VERSION definition
# that can be found in ${S}/include/libmilter/mfapi.h (see also SM_LM_VRS_* defines).
# For example, version 1.0.1 has a SMFI_VERSION of 0x01000001.
#
# See check in src_prepare too.
SENDMAIL_VER=8.17.1.9

DESCRIPTION="The Sendmail Filter API (Milter)"
HOMEPAGE="https://www.sendmail.org/"
if [[ -n $(ver_cut 4 ${SENDMAIL_VER}) ]] ; then
	# Snapshots have an extra version component (e.g. 8.17.1 vs 8.17.1.9)
	SRC_URI+="https://ftp.sendmail.org/snapshots/sendmail.${SENDMAIL_VER}.tar.gz
		ftp://ftp.sendmail.org/pub/sendmail/snapshots/sendmail.${SENDMAIL_VER}.tar.gz"
else
	SRC_URI="https://ftp.sendmail.org/sendmail.${SENDMAIL_VER}.tar.gz
		ftp://ftp.sendmail.org/pub/sendmail/sendmail.${SENDMAIL_VER}.tar.gz"
fi

S="${WORKDIR}/sendmail-${SENDMAIL_VER}"

LICENSE="Sendmail"
# We increment _pN when a new sendmail tarball comes out and change the actual
# "main version" (1.0.2 at time of writing) when the version
# of libmilter included in the tarball changes.
# We used to use $(ver_cut 1-3) here (assuming ABI stability between sendmail
# versions) but that doesn't seem to apply for sendmail snapshots.
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="ipv6 poll"

RDEPEND="!<mail-mta/sendmail-8.16.1"
BDEPEND="sys-devel/m4"

# build system patch copied from sendmail ebuild
PATCHES=(
	"${FILESDIR}"/sendmail-8.16.1-build-system.patch
	"${FILESDIR}"/${PN}-sharedlib.patch
)

src_prepare() {
	default

	extract_version_from_source() {
		# Extract "#  define SMFI_VERSION  0x01000002" from include/libmilter/mfapi.h
		local actual_libmilter_ver=$(grep -o -E -m 1 "0[xX][0-9a-fA-F]+" include/libmilter/mfapi.h)

		# SM_LM_VRS_MAJOR(v)      (((v) & 0x7f000000) >> 24)
		local actual_libmilter_ver_major=$(((actual_libmilter_ver & 0x7f000000) >> 24))

		# SM_LM_VRS_MINOR(v)      (((v) & 0x007fff00) >> 8)
		local actual_libmilter_ver_minor=$(((actual_libmilter_ver & 0x007fff00) >> 8))

		# SM_LM_VRS_PLVL(v)       ((v) & 0x0000007f)
		local actual_libmilter_ver_plvl=$((actual_libmilter_ver & 0x0000007f))

		einfo "Extracted version (hex): ${actual_libmilter_ver}"
		einfo "Extracted version (major): ${actual_libmilter_ver_major}"
		einfo "Extracted version (minor): ${actual_libmilter_ver_minor}"
		einfo "Extracted version (plvl): ${actual_libmilter_ver_plvl}"
		einfo "Extracted version (final): ${actual_libmilter_ver_major}.${actual_libmilter_ver_minor}.${actual_libmilter_ver_plvl}"

		echo ${actual_libmilter_ver_major}.${actual_libmilter_ver_minor}.${actual_libmilter_ver_plvl}
	}

	local actual_libmilter_ver_final=$(extract_version_from_source)
	if [[ $(ver_cut 1-3) != ${actual_libmilter_ver_final} ]] ; then
		eerror "Ebuild version ${PV} does not match detected version ${actual_libmilter_ver_final}!"
		eerror "Expected version: $(ver_cut 1-3)"
		eerror "Detected version: ${actual_libmilter_ver_final}"
		die "Package version ${PV} appears to be incorrect. Please check the source or rename the ebuild."
	fi

	local ENVDEF="-DNETUNIX -DNETINET -DHAS_GETHOSTBYNAME2=1"

	use ipv6 && ENVDEF+=" -DNETINET6"
	use poll && ENVDEF+=" -DSM_CONF_POLL=1"

	if use elibc_musl; then
		use ipv6 && ENVDEF+=" -DNEEDSGETIPNODE"

		eapply "${FILESDIR}"/${PN}-musl-stack-size.patch
		eapply "${FILESDIR}"/${PN}-musl-disable-cdefs.patch
	fi

	sed -e "s|@@CC@@|$(tc-getCC)|" \
		-e "s|@@CFLAGS@@|${CFLAGS}|" \
		-e "s|@@ENVDEF@@|${ENVDEF}|" \
		-e "s|@@LDFLAGS@@|${LDFLAGS}|" \
		"${FILESDIR}"/gentoo.config.m4 > devtools/Site/site.config.m4 \
		|| die "failed to generate site.config.m4"
}

src_compile() {
	emake -j1 -C libmilter AR="$(tc-getAR)" MILTER_SOVER=${PV}
}

src_install() {
	dodir /usr/$(get_libdir)

	local emakeargs=(
		DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)"
		MANROOT=/usr/share/man/man
		SBINOWN=root SBINGRP=0 UBINOWN=root UBINGRP=0
		LIBOWN=root LIBGRP=0 GBINOWN=root GBINGRP=0
		MANOWN=root MANGRP=0 INCOWN=root INCGRP=0
		MSPQOWN=root CFOWN=root CFGRP=0
		MILTER_SOVER="$(ver_cut 1-3)"
	)
	emake -C obj.*/libmilter "${emakeargs[@]}" install

	dodoc libmilter/README

	docinto html
	dodoc -r libmilter/docs/.

	if [[ ${PV} != $(ver_cut 1-3) ]] ; then
		# Move the .so file to the more specific name so it becomes a chain like
		# .so -> .so.1.0.2 -> .so.1.0.2_p2, otherwise ldconfig can get confused
		# (bug #864563).
		#
		# See comment above ${SLOT} definition above.
		mv "${ED}"/usr/$(get_libdir)/"${PN}.so.$(ver_cut 1-3)" "${ED}"/usr/$(get_libdir)/${PN}.so.${PV}
		dosym ${PN}.so.${PV} /usr/$(get_libdir)/${PN}.so.$(ver_cut 1-3)
	fi

	find "${ED}" -name '*.a' -delete || die
}
