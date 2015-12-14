# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils multilib perl-functions python-any-r1 toolchain-funcs

DESCRIPTION="easy hugepage access"
HOMEPAGE="https://github.com/libhugetlbfs/libhugetlbfs"
SRC_URI="https://github.com/libhugetlbfs/libhugetlbfs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="static-libs test"

DEPEND="test? ( ${PYTHON_DEPS} )"
RDEPEND="dev-lang/perl:="

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.9-build.patch #332517
	epatch "${FILESDIR}"/${PN}-2.6-noexec-stack.patch
	epatch "${FILESDIR}"/${PN}-2.6-fixup-testsuite.patch

	perl_set_version

	sed -i \
		-e '/^PREFIX/s:/local::' \
		-e '1iBUILDTYPE = NATIVEONLY' \
		-e '1iV = 1' \
		-e "/^LIB\(32\)/s:=.*:= $(get_libdir):" \
		-e '/^CC\(32\|64\)/s:=.*:= $(CC):' \
		-e "/^PMDIR = .*\/perl5\/TLBC/s::PMDIR = ${VENDOR_LIB}\/TLBC:" \
		Makefile || die "sed failed"
	if [ "$(get_libdir)" == "lib64" ]; then
		sed -i \
			-e "/^LIB\(32\)/s:=.*:= lib32:" \
				Makefile || die "sed failed"
	fi

	# Workaround for https://github.com/libhugetlbfs/libhugetlbfs/issues/7
	if [ ! -f "${S}"/version ] ; then
		einfo "Creating version file ..."
		echo ${PV} > "${S}"/version || die "Failed to create version file"
	fi
}

src_compile() {
	tc-export AR
	emake CC="$(tc-getCC)" libs tools
}

src_install() {
	default
	use static-libs || rm -f "${D}"/usr/$(get_libdir)/*.a
	rm "${D}"/usr/bin/oprofile* || die
}

src_test_alloc_one() {
	local hugeadm="$1"
	local sign="$2"
	local pagesize="$3"
	local pagecount="$4"
	${hugeadm} \
		--pool-pages-max ${pagesize}:${sign}${pagecount} \
	&& \
	${hugeadm} \
		--pool-pages-min ${pagesize}:${sign}${pagecount}
	return $?
}

src_test_wrapper() {
	# Never ever call die() in this function or we will leak at least
	# 64MiB memory!
	# Whoever is calling this function must make sure to clean up
	# afterwards.

	local hugeadm="$1"
	local PAGESIZES="$2"
	local rc=0

	# the testcases need 64MiB per pagesize.
	local MIN_HUGEPAGE_RAM=$((64*1024*1024))

	einfo "Starting allocation"
	local pagesize=
	for pagesize in ${PAGESIZES} ; do
		pagecount=$((${MIN_HUGEPAGE_RAM}/${pagesize}))
		einfo "  ${pagecount} @ ${pagesize}"
		src_test_alloc_one "${hugeadm}" "+" "${pagesize}" "${pagecount}"
		rc=$?
		if [[ $rc -eq 0 ]]; then
			libhugetlbfs_allocated_memory="${libhugetlbfs_allocated_memory} ${pagesize}:${pagecount}"
		else
			eerror "Failed to add ${pagecount} pages of size ${pagesize}"
			return 1
		fi
	done

	einfo "Allocation status"
	${hugeadm} --pool-list
	rc=$?
	if [[ $rc -ne 0 ]]; then
		eerror "Couldn't list HugeTLB pools"
		return 1
	fi

	if [[ -n "${libhugetlbfs_allocated_memory}" ]]; then
		# All our allocations worked, so time to run.
		einfo "Starting tests"
		cd "${S}"/tests
		local TESTOPTS="-t func"
		case $ARCH in
			amd64|ppc64)
				TESTOPTS="${TESTOPTS} -b 64"
				;;
			x86)
				TESTOPTS="${TESTOPTS} -b 32"
				;;
		esac
		# This needs a bit of work to give a nice exit code still.
		./run_tests.py ${TESTOPTS}
		rc=$?
	else
		eerror "Failed to make HugeTLB allocations."
		return 1
	fi

	return 0
}

src_test_cleanup() {
	local hugeadm="$1"
	local has_failures=0

	einfo "Cleaning up memory"
	cd "${S}"

	# Cleanup memory allocation
	local alloc=
	for alloc in ${libhugetlbfs_allocated_memory} ; do
		pagesize="${alloc/:*}"
		pagecount="${alloc/*:}"
		einfo "  ${pagecount} @ ${pagesize}"
		src_test_alloc_one "${hugeadm}" "-" "${pagesize}" "${pagecount}" || has_failures=1
	done

	return ${has_failures}
}

src_test() {
	[[ $UID -eq 0 ]] || die "Need FEATURES=-userpriv to run this testsuite"
	einfo "Building testsuite"
	emake tests || die "Failed to build tests"

	local has_failures=0
	local hugeadm='obj/hugeadm'
	libhugetlbfs_allocated_memory=''

	einfo "Planning allocation"
	local PAGESIZES="$(${hugeadm} --page-sizes-all)"

	addwrite /var/lib/

	# Need to do this before we can create the mountpoints.
	local pagesize=
	for pagesize in ${PAGESIZES} ; do
		# The kernel depends on the location :-(
		mkdir -p /var/lib/hugetlbfs/pagesize-${pagesize} || die "Failed to create directory"
		addwrite /var/lib/hugetlbfs/pagesize-${pagesize}
	done

	addwrite /proc/sys/vm/
	addwrite /proc/sys/kernel/shmall
	addwrite /proc/sys/kernel/shmmax
	addwrite /proc/sys/kernel/shmmni

	einfo "Checking HugeTLB mountpoints"
	${hugeadm} --create-mounts || die "Failed to set up hugetlb mountpoints."

	src_test_wrapper "${hugeadm}" "${PAGESIZES}" || has_failures=1

	if ! src_test_cleanup "${hugeadm}" ; then
		has_failures=1
		ewarn "Failed to clean up all allocated memory!" \
			"Check your HughTLB memory usage on your own" \
			"or reboot to free up memory."
	fi

	[[ ${has_failures} -eq 0 ]] || die "Test suite failed :("
}
