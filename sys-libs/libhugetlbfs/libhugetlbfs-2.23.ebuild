# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit toolchain-funcs python-any-r1

DESCRIPTION="Easy hugepage access"
HOMEPAGE="https://github.com/libhugetlbfs/libhugetlbfs"
SRC_URI="https://github.com/libhugetlbfs/libhugetlbfs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~s390 ~x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6-fixup-testsuite.patch
	"${FILESDIR}"/${PN}-2.23-uncompressed-man-pages.patch
	"${FILESDIR}"/${PN}-2.23-allow-building-against-glibc-2.34.patch
)

src_prepare() {
	default

	sed -i \
		-e '/^PREFIX/s:/local::' \
		-e '1iBUILDTYPE = NATIVEONLY' \
		-e '1iV = 1' \
		-e '/gzip.*MANDIR/d' \
		-e "/^LIB\(32\)/s:=.*:= $(get_libdir):" \
		-e '/^CC\(32\|64\)/s:=.*:= $(CC):' \
		-e 's@^\(ARCH\) ?=@\1 =@' \
		Makefile || die "sed failed"

	if [ "$(get_libdir)" == "lib64" ]; then
		sed -i \
			-e "/^LIB\(32\)/s:=.*:= lib32:" \
				Makefile
	fi

	# Tarballs from github don't have the version set.
	# https://github.com/libhugetlbfs/libhugetlbfs/issues/7
	[[ -f version ]] || echo "${PV}" > version
}

src_compile() {
	tc-export AR
	emake CC="$(tc-getCC)" libs tools
}

src_install() {
	default

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/*.a
}

src_test_alloc_one() {
	hugeadm="${1}"
	sign="${2}"
	pagesize="${3}"
	pagecount="${4}"

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
	[[ ${UID} -eq 0 ]] || die "Need FEATURES=-userpriv to run this testsuite"
	einfo "Building testsuite"
	emake -j1 tests

	local hugeadm='obj/hugeadm'
	local allocated=''
	local rc=0
	# the testcases need 64MiB per pagesize.
	local MIN_HUGEPAGE_RAM=$((64*1024*1024))

	einfo "Planning allocation"
	local PAGESIZES="$(${hugeadm} --page-sizes-all)"

	# Need to do this before we can create the mountpoints.
	local pagesize pagecount
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
		src_test_alloc_one "${hugeadm}" "+" "${pagesize}" "${pagecount}"

		rc=$?
		if [[ ${rc} -eq 0 ]]; then
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

		cd "${S}"/tests || die
		local TESTOPTS="-t func"
		case ${ARCH} in
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
	cd "${S}" || die
	# Cleanup memory allocation
	for alloc in ${allocated} ; do
		pagesize="${alloc/:*}"
		pagecount="${alloc/*:}"

		einfo "  ${pagecount} @ ${pagesize}"
		src_test_alloc_one "${hugeadm}" "-" "${pagesize}" "${pagecount}"
	done

	# ---------------------------------------------------------
	# --------- die is safe again after this point. -----------
	# ---------------------------------------------------------

	return ${rc}
}
