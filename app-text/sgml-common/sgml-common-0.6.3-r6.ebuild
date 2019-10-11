# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit prefix

DESCRIPTION="Base ISO character entities and utilities for SGML"
HOMEPAGE="https://www.iso.org/standard/16387.html"
SRC_URI="https://dev.gentoo.org/~floppym/dist/${PN}/${P}-gentoo.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-prefix.patch )

src_prepare() {
	# We use a hacked version of install-catalog that supports the ROOT
	# variable, puts quotes around the CATALOG files, and can be prefixed.
	cp "${FILESDIR}/${P}-install-catalog.in" "${S}/bin/install-catalog.in" \
		|| die "Copy of install-catalog.in failed"

	default
	eprefixify bin/install-catalog.in bin/sgmlwhich config/sgml.conf
}

pkg_postinst() {
	local installer="${EROOT%/}/usr/bin/install-catalog"
	if [[ ! -x ${installer} ]]; then
		eerror "install-catalog not found! Something went wrong!"
		die "install-catalog not found! Something went wrong!"
	fi

	einfo "Installing Catalogs..."
	"$installer" --add \
		"${EROOT%/}"/etc/sgml/sgml-ent.cat \
		"${EROOT%/}"/usr/share/sgml/sgml-iso-entities-8879.1986/catalog
	"$installer" --add \
		"${EROOT%/}"/etc/sgml/sgml-docbook.cat \
		"${EROOT%/}"/etc/sgml/sgml-ent.cat

	local file
	while IFS="" read -d $'\0' -r file; do
		einfo "Fixing ${file}"
		awk '/"$/ { print $1 " " $2 }
			! /"$/ { print $1 " \"" $2 "\"" }' ${file} > ${file}.new || die "awk failed"
		mv ${file}.new ${file} || die "mv failed"
	done < <(find "${EROOT%/}/etc/sgml/" -name "*.cat" -o -name "catalog" -print0)
}

pkg_prerm() {
	cp "${EROOT%/}/usr/bin/install-catalog" "${T}" || die "cp failed"
}

pkg_postrm() {
	if [[ ! -x ${T}/install-catalog ]]; then
		return
	fi

	einfo "Removing Catalogs..."
	if [[ -e ${EROOT%/}/etc/sgml/sgml-ent.cat ]]; then
		"${T}"/install-catalog --remove \
			"${EROOT%/}"/etc/sgml/sgml-ent.cat \
			"${EROOT%/}"/usr/share/sgml/sgml-iso-entities-8879.1986/catalog \
		|| die "install-catalog failed"
	fi

	if [[ -e ${EROOT%/}/etc/sgml/sgml-docbook.cat ]]; then
		"${T}"/install-catalog --remove \
			"${EROOT%/}"/etc/sgml/sgml-docbook.cat \
			"${EROOT%/}"/etc/sgml/sgml-ent.cat \
		|| die "install-catalog failed"
	fi
}
