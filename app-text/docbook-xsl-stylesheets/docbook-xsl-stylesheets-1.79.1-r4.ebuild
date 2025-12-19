# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"
inherit ruby-single

DOCBOOKDIR="/usr/share/sgml/${PN/-//}"
MY_PN="${PN%-stylesheets}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XSL Stylesheets for Docbook"
HOMEPAGE="https://github.com/docbook/wiki/wiki"
SRC_URI="https://downloads.sourceforge.net/docbook/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="ruby"
# Makefile is broken since 1.76.0
RESTRICT="test"

RDEPEND="
	>=app-text/build-docbook-catalog-1.1
	ruby? ( ${RUBY_DEPS} dev-ruby/rexml )
"

PATCHES=(
	"${FILESDIR}"/nonrecursive-string-subst.patch
)

src_prepare() {
	default

	# Delete the unnecessary Java-related stuff and other tools as they
	# bloat the stage3 tarballs massively. See bug #575818.
	rm -rv extensions/ tools/ || die
	find \( -name build.xml -o -name build.properties \) \
		 -printf "removed %p\n" -delete || die

	if ! use ruby; then
		rm -rv epub/ || die
	fi
}

# The makefile runs tests, not builds.
src_compile() { :; }

src_test() {
	emake check
}

src_install() {
	# The changelog is now zipped, and copied as the RELEASE-NOTES, so we
	# don't need to install it
	dodoc AUTHORS BUGS NEWS README RELEASE-NOTES.txt TODO

	insinto ${DOCBOOKDIR}
	doins VERSION VERSION.xsl

	local i
	for i in */; do
		i=${i%/}

		for doc in ChangeLog README; do
			if [[ -e ${i}/${doc} ]]; then
				newdoc ${i}/${doc} ${doc}.${i}
				rm ${i}/${doc} || die
			fi
		done

		doins -r ${i}
	done

	if use ruby; then
		local cmd="dbtoepub${MY_PN#docbook-xsl}"

		# we can't use a symlink or it'll look for the library in the wrong path
		newbin - ${cmd} <<-EOF
			#!/usr/bin/env ruby

			load "${EPREFIX}${DOCBOOKDIR}/epub/bin/dbtoepub"
		EOF
	fi
}

pkg_postinst() {
	# See bug #816303 for rationale behind die
	"${EROOT}"/usr/sbin/build-docbook-catalog || die "Failed to regenerate docbook catalog. Is /run mounted?"
}

pkg_postrm() {
	# See bug #816303 for rationale behind die
	"${EROOT}"/usr/sbin/build-docbook-catalog || die "Failed to regenerate docbook catalog. Is /run mounted?"
}
