# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libhugetlbfs/libhugetlbfs-2.18.ebuild,v 1.1 2014/04/25 08:48:48 radhermit Exp $

EAPI="4"

inherit eutils multilib toolchain-funcs

DESCRIPTION="easy hugepage access"
HOMEPAGE="http://libhugetlbfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.9-build.patch #332517
	epatch "${FILESDIR}"/${PN}-2.6-noexec-stack.patch
	epatch "${FILESDIR}"/${PN}-2.6-fixup-testsuite.patch
	sed -i \
		-e '/^PREFIX/s:/local::' \
		-e '1iBUILDTYPE = NATIVEONLY' \
		-e '1iV = 1' \
		-e "/^LIB\(32\)/s:=.*:= $(get_libdir):" \
		-e '/^CC\(32\|64\)/s:=.*:= $(CC):' \
		Makefile
	if [ "$(get_libdir)" == "lib64" ]; then
		sed -i \
			-e "/^LIB\(32\)/s:=.*:= lib32:" \
				Makefile
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
	hugeadm="$1"
	sign="$2"
	pagesize="$3"
	pagecount="$4"
	${hugeadm} \
		--pool-pages-max ${pagesize}:${sign}${pagecount} \
	&& \
	${hugeadm} \
		--pool-pages-min ${pagesize}:${sign}${pagecount}
	return $?
}

# die is NOT allowed in this src_test block after the marked point, so that we
# can clean up memory allocation. You'll leak at LEAST 64MiB per run otherwise.
src_test() {
	[[ $UID -eq 0 ]] || die "Need FEATURES=-userpriv to run this testsuite"
	einfo "Building testsuite"
	emake -j1 tests || die "Failed to build tests"

	hugeadm='obj/hugeadm'
	allocated=''
	rc=0
	# the testcases need 64MiB per pagesize.
	MIN_HUGEPAGE_RAM=$((64*1024*1024))

	einfo "Planning allocation"
	PAGESIZES="$(${hugeadm} --page-sizes-all)"

	# Need to do this before we can create the mountpoints.
	for pagesize in ${PAGESIZES} ; do
		# The kernel depends on the location :-(
		mkdir -p /var/lib/hugetlbfs/pagesize-${pagesize}
		addwrite /var/lib/hugetlbfs/pagesize-${pagesize}
	done
	addwrite /proc/sys/vm/
	addwrite /proc/sys/kernel/shmall
	addwrite /proc/sys/kernel/shmmax
	addwrite /proc/sys/kernel/shmmni

	einfo "Checking HugeTLB mountpoints"
	${hugeadm} --create-mounts || die "Failed to set up hugetlb mountpoints."

	# -----------------------------------------------------
	# --------- die is unsafe after this point. -----------
	# -----------------------------------------------------

	einfo "Starting allocation"
	for pagesize in ${PAGESIZES} ; do
		pagecount=$((${MIN_HUGEPAGE_RAM}/${pagesize}))
		einfo "  ${pagecount} @ ${pagesize}"
		addwrite /var/lib/hugetlbfs/pagesize-${pagesize}
		src_test_alloc_one "$hugeadm" "+" "${pagesize}" "${pagecount}"
		rc=$?
		if [[ $rc -eq 0 ]]; then
			allocated="${allocated} ${pagesize}:${pagecount}"
		else
			eerror "Failed to add ${pagecount} pages of size ${pagesize}"
		fi
	done

	einfo "Allocation status"
	${hugeadm} --pool-list

	if [[ -n "${allocated}" ]]; then
		# All our allocations worked, so time to run.
		einfo "Starting tests"
		cd "${S}"/tests
		TESTOPTS="-t func"
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
		rc=1
	fi

	einfo "Cleaning up memory"
	cd "${S}"
	# Cleanup memory allocation
	for alloc in ${allocated} ; do
		pagesize="${alloc/:*}"
		pagecount="${alloc/*:}"
		einfo "  ${pagecount} @ ${pagesize}"
		src_test_alloc_one "$hugeadm" "-" "${pagesize}" "${pagecount}"
	done

	# ---------------------------------------------------------
	# --------- die is safe again after this point. -----------
	# ---------------------------------------------------------

	return $rc
}
