# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AVM="AvailabilityVersions-26.50.4"
DESCRIPTION="System headers provided by XNU-${PV}, macOS 10.12.6"
HOMEPAGE="https://opensource.apple.com/source/xnu"
SRC_URI="https://opensource.apple.com/tarballs/xnu/xnu-${PV}.tar.gz
	https://opensource.apple.com/tarballs/${AVM%-*}/${AVM}.tar.gz"

LICENSE="APSL-2"
SLOT="10.12"
KEYWORDS="~x64-macos"
IUSE="+man"

S=${WORKDIR}/xnu-${PV}

src_prepare() {
	default

	# we don't install availability.pl, but generation needs it
	local avpl="${WORKDIR}/${AVM}/availability.pl"
	sed -i -e 's:${SDKROOT}/usr/local/libexec/availability.pl:'"${avpl}"':' \
		bsd/sys/make_symbol_aliasing.sh || die
}

src_compile() {
	# crappy scripts that just about do the job
	./bsd/kern/makesyscalls.sh \
		bsd/kern/syscalls.master header >& /dev/null || die
	./bsd/sys/make_posix_availability.sh \
		_posix_availability.h >& /dev/null || die
	./bsd/sys/make_symbol_aliasing.sh \
		dummy _symbol_aliasing.h >& /dev/null || die
}

src_install() {
	insinto /usr/include
	doins libsyscall/wrappers/gethostuuid.h
	doins libsyscall/wrappers/libproc/libproc.h
	doins -r libsyscall/mach/mach

	# generated during src_compile
	insinto /usr/include/sys
	doins syscall.h _posix_availability.h _symbol_aliasing.h

	get_files_list() {
		local s="$1"
		local f="$2"/Makefile
		sed -n -e '/^'"${s}"' \?=/,/^$/p' "${f}" \
			| sed -e '1s/^'"${s}"' \?=//' -e '/\s*#/d' \
			| sed -e 's/\\$//' -e '/^[A-Z]\+ \?=/,/^$/d'
	}

	get_datafiles() {
		local entry
		get_files_list DATAFILES "$@" | while read entry ; do
			[[ ${entry} == '${'?*'}' ]] \
				&& get_files_list ${entry:2:-1} "$@" \
				|| echo "${entry}"
		done
	}

	local d
	local files

	pushd bsd > /dev/null || die

	for d in bsm i386 machine miscfs/{devfs,specfs,union} \
		net netinet{,6} netkey nfs sys{,/_types} uuid vfs ;
	do
		insinto /usr/include/${d}
		files=( $(get_datafiles ${d}) )
		einfo "${d}:" ${files[*]}
		doins ${files[@]/#/$d/}
	done

	use man && doman man/man*/*.[234579]

	popd > /dev/null || die

	pushd osfmk > /dev/null || die

	for d in device mach{,/i386,/machine} mach_debug ; do
		insinto /usr/include/${d}
		files=( $(get_datafiles ${d}) )
		einfo "${d}:" ${files[*]}
		doins ${files[@]/#/$d/}
	done

	for d in i386 ; do
		insinto /usr/include/${d}
		files=( $(get_files_list INSTALL_MD_LIST ${d}) )
		einfo "${d}:" ${files[*]}
		doins ${files[@]/#/$d/}
	done

	popd > /dev/null || die

	pushd libkern > /dev/null || die

	for d in libkern{,/i386,/machine,/c++,/crypto} ; do
		insinto /usr/include/${d}
		files=( $(get_datafiles ${d}) )
		einfo "${d}:" ${files[*]}
		doins ${files[@]/#/$d/}
	done

	popd > /dev/null || die
}
