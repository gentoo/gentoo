# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LDS
DIST_VERSION=1.17
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Interface to Distributed Annotation System"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="coldspringharbor"

RDEPEND=">=virtual/perl-IO-Compress-1.0
	sci-biology/bioperl
	>=dev-perl/HTML-Parser-3
	>=dev-perl/libwww-perl-5
	>=virtual/perl-MIME-Base64-2.12"
BDEPEND="${RDEPEND}
"

optdep_notice() {
	local i
	elog "This package has several modules which may require additional dependencies"
	elog "to use. However, it is up to you to install them separately if you need this"
	elog "optional functionality:"
	elog
	i="$(if has_version 'dev-perl/CGI'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i dev-perl/CGI"
	elog "     - Running a reference DAS server driven by an AGP File via"
	elog "       Bio::Das::AGPServer::Daemon"

	if use test; then
		elog
		elog "This module will perform additional tests if these dependencies are"
		elog "pre-installed"
	fi
}

src_test() {
	local MODULES=(
		"Bio::Das ${DIST_VERSION}"
		"Bio::Das::AGPServer::Config 1.0"
		"Bio::Das::AGPServer::Parser"
		"Bio::Das::AGPServer::SQLStorage"
		"Bio::Das::AGPServer::SQLStorage::CSV::DB"
		"Bio::Das::AGPServer::SQLStorage::MySQL::DB"
		"Bio::Das::DSN"
		"Bio::Das::Feature 0.91"
		"Bio::Das::FeatureIterator 0.01"
		"Bio::Das::HTTP::Fetch 1.11"
		"Bio::Das::Map 1.01"
		"Bio::Das::Request"
		"Bio::Das::Request::Dnas"
		"Bio::Das::Request::Dsn"
		"Bio::Das::Request::Entry_points"
		"Bio::Das::Request::Feature2Segments"
		"Bio::Das::Request::Features"
		"Bio::Das::Request::Sequences"
		"Bio::Das::Request::Stylesheet"
		"Bio::Das::Request::Types"
		"Bio::Das::Segment 0.91"
		"Bio::Das::Stylesheet 1.00"
		"Bio::Das::Type"
		"Bio::Das::TypeHandler"
		"Bio::Das::Util 0.01"
	)
	has_version dev-perl/CGI && MODULES+=(
		"Bio::Das::AGPServer::Daemon"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	if has "network" ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		perl-module_src_test
	else
		ewarn "Functional parts of these tests require network access"
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Bio-Das"
	fi
}
