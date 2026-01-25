# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Generate locales based upon the config file /etc/locale.gen"
HOMEPAGE="https://gitweb.gentoo.org/proj/locale-gen.git/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/locale-gen.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/locale-gen.git/snapshot/${P}.tar.bz2"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="GPL-2"
SLOT="0"

BDEPEND="
	>=dev-lang/perl-5.36
	dev-perl/File-Slurper
"
RDEPEND="
	>=dev-lang/perl-5.36
	!<sys-libs/glibc-2.37-r3
"

src_prepare() {
	# EPREFIX is readonly.
	local -x MY_EPREFIX=${EPREFIX}

	eapply_user

	perl -pi -e '$f //= ($. == 1 && s/^#!\h*\K/$ENV{MY_EPREFIX}/); END { exit !$f }' "${PN}" \
	|| die "Failed to prefixify ${PN}"
}

src_install() {
	dosbin locale-gen
	doman *.[0-8]
	insinto /etc
	{
		cat <<-'EOF' &&
		# This file defines which locales to incorporate into the glibc locale archive.
		# See the locale.gen(5) and locale-gen(8) man pages for more details.

		EOF
		if [[ -e ${EROOT}/usr/share/i18n/SUPPORTED ]]; then
			# Run the interpreter by name so as not to have to prefixify.
			perl mkconfig "${EROOT}"
		else
			ewarn "Skipping the incorporation of locale.gen examples because the SUPPORTED file is absent"
		fi
	} | newins - locale.gen
	if (( PIPESTATUS[0] || PIPESTATUS[1] )); then
		die "Failed to generate and/or install locale.gen"
	fi
	keepdir /usr/lib/locale
}

pkg_postinst() {
	while read -r; do ewarn "${REPLY}"; done <<-'EOF'
	As of version 3.10, the locale.gen(5) config file grammar has been
	simplified. For instance, "en_US.UTF-8 UTF-8" may instead be written as
	"en_US UTF-8", or even "en_US". The grammar remains backward compatible with
	version 3.9, so there is no requirement to update the /etc/locale.gen file.
	EOF
}
