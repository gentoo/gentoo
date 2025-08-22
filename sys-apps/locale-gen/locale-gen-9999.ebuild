# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Generate locales based upon the config file /etc/locale.gen"
HOMEPAGE="https://gitweb.gentoo.org/proj/locale-gen.git/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/locale-gen.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/locale-gen.git/snapshot/${P}.tar.bz2"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
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

	perl -pi -e '$f //= ($. == 1 && s/^#!\K\//$ENV{MY_EPREFIX}\//); END { exit !$f }' "${PN}" \
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
		# Run the interpreter by name so as not to have to prefixify mkconfig.
		perl mkconfig "${EROOT}"
	} | newins - locale.gen
	if (( PIPESTATUS[0] || PIPESTATUS[1] )); then
		die "Failed to generate and/or install locale.gen"
	fi
	keepdir /usr/lib/locale
}
