# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/maatkit/maatkit-7540-r1.ebuild,v 1.4 2014/11/27 23:46:23 dilfridge Exp $

EAPI=5

inherit perl-app perl-module toolchain-funcs

DESCRIPTION="essential command-line utilities for MySQL"
HOMEPAGE="http://www.maatkit.org/"
SRC_URI="http://maatkit.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="udf"

COMMON_DEPEND="dev-perl/DBI
	dev-perl/DBD-mysql
	virtual/perl-Time-HiRes"
RDEPEND="${COMMON_DEPEND}
	virtual/perl-Getopt-Long
	virtual/perl-Time-Local
	virtual/perl-Digest-MD5
	virtual/perl-IO-Compress
	virtual/perl-File-Temp
	virtual/perl-File-Spec
	virtual/perl-Time-HiRes
	virtual/perl-Scalar-List-Utils
	dev-perl/TermReadKey"
DEPEND="${COMMON_DEPEND}
	udf? ( dev-db/mysql )
	virtual/perl-ExtUtils-MakeMaker"

mysql-udf_src_compile() {
	local udfdir="${T}/udf/"
	mkdir -p "${udfdir}"

	local udfname udffile udfext udfoutpath
	udfname="${1}"
	udfext=".so"
	udffile="${udfname}${udfext}"
	udfoutpath="${udfdir}/${udffile}"
	shift
	CXX="$(tc-getCXX)"
	local src="$@"
	if [ -z "$@" ]; then
		src="${udfname}.cc"
	fi
	for f in ${src} ; do
		[ -f "${f}" ] || \
			die "UDF ${udfname}: Cannot find source file ${f} to compile"
	done
	einfo "UDF ${udfname}: compiling from ${src}"
	${CXX} \
		${CXXFLAGS} -I/usr/include/mysql \
		${LDFLAGS} -fPIC -shared -o "${udfoutpath}" $src \
		|| die "UDF ${udfname}: Failed to compile"
}

mysql-udf_src_install() {
	local udfdir="${T}/udf/"
	local udfname udfext udffile udfoutpath
	udfname="${1}"
	udfext=".so"
	udffile="${udfname}${udfext}"
	udfoutpath="${udfdir}/${udffile}"
	insinto /usr/$(get_libdir)/mysql/plugins
	doins "${udfoutpath}"
}

udf_done_intro=0
mysql-udf_pkg_postinst() {
	local udfname udffile udfext udffunc udfreturn
	udfname="${1}"
	udfext=".so"
	udffile="${udfname}${udfext}"
	udffunc="${2}"
	udfreturn="${3}"
	if [ ${udf_done_intro} -eq 0 ]; then
		elog "To use the UDFs that were built:"
		elog "Update your configuration to include 'plugin_dir=/usr/$(get_libdir)/mysql/plugins'"
		elog "Issue the following commands as a user with FUNCTION privileges:"
		udf_done_intro=1
	fi
	elog "CREATE FUNCTION ${udffunc} RETURNS ${udfreturn} SONAME '${udffile}'"
}

src_compile() {
	perl-app_src_compile
	if use udf; then
		cd "${S}"/udf
		mysql-udf_src_compile murmur_udf
		mysql-udf_src_compile fnv_udf
	fi
}

src_install() {
	perl-module_src_install
	if use udf; then
		mysql-udf_src_install murmur_udf
		mysql-udf_src_install fnv_udf
	fi
}

pkg_postinst() {
	if use udf; then
		mysql-udf_pkg_postinst murmur_udf murmur_hash INTEGER
		mysql-udf_pkg_postinst fnv_udf fnv_64 INTEGER
	fi
}
