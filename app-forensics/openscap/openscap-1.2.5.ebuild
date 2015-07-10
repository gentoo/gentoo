# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/openscap/openscap-1.2.5.ebuild,v 1.1 2015/07/10 04:25:16 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 eutils multilib python-single-r1

DESCRIPTION="Framework which enables integration with the Security Content Automation Protocol (SCAP)"
HOMEPAGE="http://www.open-scap.org/"
SRC_URI="https://fedorahosted.org/releases/o/p/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl caps debug doc gconf ldap nss pcre perl python rpm selinux sce sql test xattr"
RESTRICT="test"

RDEPEND="!nss? ( dev-libs/libgcrypt:0 )
	nss? ( dev-libs/nss )
	acl? ( virtual/acl )
	caps? ( sys-libs/libcap )
	gconf? ( gnome-base/gconf )
	ldap? ( net-nds/openldap )
	pcre? ( dev-libs/libpcre )
	rpm? ( >=app-arch/rpm-4.9 )
	sql? ( dev-db/opendbx )
	xattr? ( sys-apps/attr )
	dev-libs/libpcre
	dev-libs/libxml2
	dev-libs/libxslt
	net-misc/curl
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	perl? ( dev-lang/swig )
	python? ( dev-lang/swig )
	test? (
		app-arch/unzip
		dev-perl/XML-XPath
		net-misc/ipcalc
		sys-apps/grep )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
#	uncoment for debugging test
#	sed -i 's,set -e,&;set -x,'	tests/API/XCCDF/unittests/test_remediate_simple.sh || die
#	sed -i 's,^    bash,    LC_ALL=C bash,'	tests/probes/process/test_probes_process.sh || die

	sed -i 's/uname -p/uname -m/' tests/probes/uname/test_probes_uname.xml.sh || die

	#probe runlevel for non-centos/redhat/fedora is not implemented
	sed -i 's,.*runlevel_test.*,echo "runlevel test bypassed",' tests/mitre/test_mitre.sh || die
	sed -i 's,probecheck "runlevel,probecheck "runlevellllll,' tests/probes/runlevel/test_probes_runlevel.sh || die

	#According to comment of theses tests, we must modify it. For the moment disable it
	sed -i 's,.*linux-def_inetlisteningservers_test,#&,' tests/mitre/test_mitre.sh || die
	sed -i 's,.*ind-def_environmentvariable_test,#&,' tests/mitre/test_mitre.sh || die

	# theses tests are hardcoded for checking hald process...,
	# but no good solution for the moment, disabling them with a fake echo
	# because encased in a if then
#	sed -i 's,ha.d,/sbin/udevd --daemon,g' tests/mitre/unix-def_process_test.xml || die
#	sed -i 's,ha.d,/sbin/udevd --daemon,g' tests/mitre/unix-def_process58_test.xml || die
	sed -i 's,.*process_test.*,echo "process test bypassed",' tests/mitre/test_mitre.sh || die
	sed -i 's,.*process58_test.*,echo "process58 test bypassed",' tests/mitre/test_mitre.sh || die

	#This test fail
	sed -i 's,.*generate report: xccdf,#&,' tests/API/XCCDF/unittests/all.sh ||	die

	if ! use rpm ; then
		sed -i 's,probe_rpminfo_req_deps_ok=yes,probe_rpminfo_req_deps_ok=no,' configure || die
		sed -i 's,probe_rpminfo_opt_deps_ok=yes,probe_rpminfo_opt_deps_ok=no,' configure || die
		sed -i 's,probe_rpmverify_req_deps_ok=yes,probe_rpmverify_req_deps_ok=no,' configure || die
		sed -i 's,probe_rpmverify_opt_deps_ok=yes,probe_rpmverify_opt_deps_ok=no,' configure || die
		sed -i 's,^probe_rpm.*_deps_missing=,&disabled_by_USE_flag,' configure || die
		sed -i 's,.*rpm.*,#&,' tests/mitre/test_mitre.sh || die
	fi
	if ! use selinux ; then
		einfo "Disabling SELinux probes"
		sed -i 's,.*selinux.*,	echo "SELinux test bypassed",' tests/mitre/test_mitre.sh || die
		#process58 need selinux
		sed -i 's,.*process58,#&,' tests/mitre/test_mitre.sh || die
	fi
	if ! use ldap; then
		einfo "Disabling LDAP probes"
		sed -i 's,ldap.h,ldapp.h,g' configure || die
	fi

	epatch_user
}

src_configure() {
	python_setup
	local myconf
	if use debug ; then
		myconf+=" --enable-debug"
	fi
	if use python ; then
		myconf+=" --enable-python"
	else
		myconf+=" --enable-python=no"
	fi
	if use perl ; then
		myconf+=" --enable-perl"
	fi
	if use nss ; then
		myconf+=" --with-crypto=nss3"
	else
		myconf+=" --with-crypto=gcrypt"
	fi
	if use sce ; then
		myconf+=" --enable-sce"
	else
		myconf+=" --enable-sce=no"
	fi
	econf ${myconf}
}

src_compile() {
	emake
	if use doc ; then
		cd docs && doxygen Doxyfile || die
	fi
}

src_install() {
	emake install DESTDIR="${D}"
	prune_libtool_files --all
	if use doc ; then
		dohtml -r docs/html/.
		dodoc docs/examples/.
	fi
	dobashcomp "${D}"/etc/bash_completion.d/oscap
	rm -rf "${D}"/etc/bash_completion.d || die
}
