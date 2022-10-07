#!/usr/bin/env bash
# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

source tests-common.sh || exit

inherit unpacker

# silence the output
unpack_banner() { :; }

TESTFILE=test.in
TESTDIR=$(mktemp -d || die)
trap 'cd - >/dev/null && rm -r "${TESTDIR}"' EXIT

# prepare some test data
# NB: we need something "compressible", as compress(1) will return
# an error if the file "is larger than before compression"
cp ../unpacker.eclass "${TESTDIR}/${TESTFILE}" || die
cd "${TESTDIR}" || die

test_unpack() {
	local archive=${1}
	local unpacked=${2}
	local deps=${3}
	local packcmd=${4}

	local x
	for x in ${deps}; do
		if ! type "${x}" &>/dev/null; then
			ewarn "Skipping ${archive}, tool ${x} not found"
			return
		fi
	done

	rm -rf testdir || die
	mkdir -p testdir || die

	tbegin "unpacking ${archive}"
	eval "${packcmd}"
	assert "packing ${archive} failed"
	cd testdir || die

	# create a symlink to flush out compressor issues and resemble distdir more
	# https://bugs.gentoo.org/873352
	ln -s "../${archive}" "${archive}" || die

	local out
	out=$(
		_unpacker "${archive}" 2>&1
	)
	ret=$?
	if [[ ${ret} -eq 0 ]]; then
		if [[ ! -f ${unpacked} ]]; then
			eerror "${unpacked} not found after unpacking"
			ret=1
		elif ! diff -u "${unpacked}" "../${TESTFILE}"; then
			eerror "${unpacked} different than input"
			ret=1
		fi
	fi
	[[ ${ret} -ne 0 ]] && echo "${out}" >&2
	tend ${ret}

	cd .. || die
	rm -f "${archive}" || die
}

test_compressed_file() {
	local suffix=${1}
	local tool=${2}

	test_unpack "test${suffix}" test "${tool}" \
		"${tool} -c \${TESTFILE} > \${archive}"
}

test_compressed_file_multistream() {
	local suffix=${1}
	local tool=${2}

	test_unpack "test+multistream${suffix}" "test+multistream" "${tool}" \
		"head -n 300 \${TESTFILE} | ${tool} -c > \${archive} &&
		tail -n +301 \${TESTFILE} | ${tool} -c >> \${archive}"
}

test_compressed_file_with_junk() {
	local suffix=${1}
	local tool=${2}
	local flag=${3}

	test_unpack "test+junk${suffix}" "test+junk" "${tool}" \
		"${tool} -c \${TESTFILE} > \${archive} && cat test.in >> \${archive}"
}

test_compressed_tar() {
	local suffix=${1}
	local tool=${2}

	test_unpack "test${suffix}" test.in "tar ${tool}" \
		"tar -c \${TESTFILE} | ${tool} -c > \${archive}"
}

test_compressed_cpio() {
	local suffix=${1}
	local tool=${2}

	test_unpack "test${suffix}" test.in "cpio ${tool}" \
		"cpio -o --quiet <<<\${TESTFILE} | ${tool} -c > \${archive}"
}

create_deb() {
	local suffix=${1}
	local tool=${2}
	local archive=${3}
	local infile=${4}

	echo 2.0 > debian-binary || die
	: > control || die
	tar -cf control.tar control || die
	tar -c "${infile}" | ${tool} > "data.tar${suffix}"
	assert "packing data.tar${suffix} failed"
	ar r "${archive}" debian-binary control.tar "data.tar${suffix}" \
		2>/dev/null || die
	rm -f control control.tar "data.tar${suffix}" debian-binary || die
}

test_deb() {
	local suffix=${1}
	local tool=${2}
	local tool_cmd

	if [[ -n ${tool} ]]; then
		tool_cmd="${tool} -c"
	else
		tool_cmd=cat
	fi

	test_unpack "test-${tool}_1.2.3_noarch.deb" test.in "ar tar ${tool}" \
		"create_deb '${suffix}' '${tool_cmd}' \${archive} \${TESTFILE}"
	# also test with the handwoven implementation used on Prefix
	EPREFIX=/foo \
	test_unpack "test_pfx-${tool}_1.2.3_noarch.deb" test.in "ar tar ${tool}" \
		"create_deb '${suffix}' '${tool_cmd}' \${archive} \${TESTFILE}"
}

create_gpkg() {
	local suffix=${1}
	local tool=${2}
	local archive=${3}
	local infile=${4}
	local gpkg_dir=${archive%.gpkg.tar}

	mkdir image metadata "${gpkg_dir}" || die
	cp "${infile}" image/ || die
	tar -c metadata | ${tool} > "${gpkg_dir}/metadata.tar${suffix}"
	assert "packing metadata.tar${suffix} failed"
	: > "${gpkg_dir}/metadata.tar${suffix}.sig" || die
	tar -c image | ${tool} > "${gpkg_dir}/image.tar${suffix}"
	assert "packing image.tar${suffix} failed"
	: > "${gpkg_dir}/image.tar${suffix}.sig" || die
	: > "${gpkg_dir}"/gpkg-1 || die
	tar -cf "${archive}" --format=ustar \
		"${gpkg_dir}"/{gpkg-1,{metadata,image}.tar"${suffix}"} || die
	rm -r image metadata "${gpkg_dir}" || die
}

test_gpkg() {
	local suffix=${1}
	local tool=${2}
	local tool_cmd

	if [[ -n ${tool} ]]; then
		tool_cmd="${tool} -c"
	else
		tool_cmd=cat
	fi

	test_unpack "test-${tool}-1.2.3-1.gpkg.tar" \
		"test-${tool}-1.2.3-1/image/test.in" "tar ${tool}" \
		"create_gpkg '${suffix}' '${tool_cmd}' \${archive} \${TESTFILE}"
}

create_makeself() {
	local comp_opt=${1}
	local archive=${2}
	local infile=${3}

	mkdir test || die
	cp "${infile}" test/ || die
	makeself --quiet "${comp_opt}" test "${archive}" test : || die
	rm -rf test || die
}

test_makeself() {
	local comp_opt=${1}
	local tool=${2}

	test_unpack "makeself-${tool}.sh" test.in "makeself ${tool}" \
		"create_makeself '${comp_opt}' \${archive} \${TESTFILE}"
}

test_reject_junk() {
	local suffix=${1}
	local archive=test${1}

	rm -rf testdir || die
	mkdir -p testdir || die

	tbegin "rejecting junk named ${archive}"
	cat test.in >> "${archive}" || die
	cd testdir || die
	(
		# some decompressors (e.g. cpio) are very verbose about junk
		_unpacker "../${archive}" &>/dev/null
	)
	[[ $? -ne 0 ]]
	ret=$?
	tend ${ret}

	cd .. || die
	rm -f "${archive}" || die
}

test_online() {
	local url=${1}
	local b2sum=${2}
	local unpacked=${3}
	local unp_b2sum=${4}

	local filename=${url##*/}
	local archive=${DISTDIR}/${filename}

	if [[ ! -f ${archive} ]]; then
		if [[ ${UNPACKER_TESTS_ONLINE} != 1 ]]; then
			ewarn "Skipping ${filename} test, distfile not found"
			return
		fi

		if ! wget -O "${archive}" "${url}"; then
			die "Fetching ${archive} failed"
		fi
	fi

	local real_sum=$(b2sum "${archive}" | cut -d' ' -f1)
	if [[ ${real_sum} != ${b2sum} ]]; then
		eerror "Incorrect b2sum on ${filename}"
		eerror "  expected: ${b2sum}"
		eerror "     found: ${real_sum}"
		die "Incorrect b2sum on ${filename}"
	fi

	rm -rf testdir || die
	mkdir -p testdir || die

	tbegin "unpacking ${filename}"
	cd testdir || die

	ln -s "${archive}" "${filename}" || die

	local out
	out=$(
		_unpacker "${archive}" 2>&1
	)
	ret=$?
	if [[ ${ret} -eq 0 ]]; then
		if [[ ! -f ${unpacked} ]]; then
			eerror "${unpacked} not found after unpacking"
			ret=1
		else
			real_sum=$(b2sum "${unpacked}" | cut -d' ' -f1)
			if [[ ${real_sum} != ${unp_b2sum} ]]; then
				eerror "Incorrect b2sum on unpacked file ${unpacked}"
				eerror "  expected: ${unp_b2sum}"
				eerror "     found: ${real_sum}"
				ret=1
			fi
		fi
	fi
	[[ ${ret} -ne 0 ]] && echo "${out}" >&2
	tend ${ret}

	cd .. || die
}

test_compressed_file .bz2 bzip2
test_compressed_file .Z compress
test_compressed_file .gz gzip
test_compressed_file .lzma lzma
test_compressed_file .xz xz
test_compressed_file .lz lzip
test_compressed_file .zst zstd
test_compressed_file .lz4 lz4
test_compressed_file .lzo lzop

test_compressed_file_multistream .bz2 bzip2
test_compressed_file_multistream .gz gzip
test_compressed_file_multistream .xz xz
test_compressed_file_multistream .lz lzip
test_compressed_file_multistream .zst zstd

test_compressed_file_with_junk .bz2 bzip2
test_compressed_file_with_junk .lz lzip

test_unpack test.tar test.in tar 'tar -cf ${archive} ${TESTFILE}'
test_compressed_tar .tar.bz2 bzip2
test_compressed_tar .tbz bzip2
test_compressed_tar .tbz2 bzip2
test_compressed_tar .tar.Z compress
test_compressed_tar .tar.gz gzip
test_compressed_tar .tgz gzip
test_compressed_tar .tar.lzma lzma
test_compressed_tar .tar.xz xz
test_compressed_tar .txz xz
test_compressed_tar .tar.lz lzip
test_compressed_tar .tar.zst zstd
test_compressed_tar .tar.lz4 lz4
test_compressed_tar .tar.lzo lzop

test_unpack test.cpio test.in cpio 'cpio -o --quiet <<<${TESTFILE} > ${archive}'
test_compressed_cpio .cpio.bz2 bzip2
test_compressed_cpio .cpio.Z compress
test_compressed_cpio .cpio.gz gzip
test_compressed_cpio .cpio.lzma lzma
test_compressed_cpio .cpio.xz xz
test_compressed_cpio .cpio.lz lzip
test_compressed_cpio .cpio.zst zstd
test_compressed_cpio .cpio.lz4 lz4
test_compressed_cpio .cpio.lzo lzop

test_deb
test_deb .gz gzip
test_deb .xz xz
test_deb .bz2 bzip2
test_deb .lzma lzma

test_gpkg
test_gpkg .gz gzip
test_gpkg .bz2 bzip2
test_gpkg .lz4 lz4
test_gpkg .lz lzip
test_gpkg .lzma lzma
test_gpkg .lzo lzop
test_gpkg .xz xz
test_gpkg .zst zstd

test_makeself --gzip gzip
test_makeself --zstd zstd
test_makeself --bzip2 bzip2
test_makeself --xz xz
test_makeself --lzo lzop
test_makeself --lz4 lz4
test_makeself --compress compress
test_makeself --base64 base64
test_makeself --nocomp tar

test_unpack test.zip test.in zip 'zip -q ${archive} ${TESTFILE}'
# test handling non-adjusted zip with junk prepended
test_unpack test.zip test.in zip \
	'zip -q testdir/tmp.zip ${TESTFILE} && cat test.in testdir/tmp.zip > ${archive}'
test_unpack test.7z test.in 7z '7z -bso0 a ${archive} ${TESTFILE}'
test_unpack test.lha test.in lha 'lha a -q ${archive} ${TESTFILE}'
test_unpack test.lzh test.in lha 'lha a -q ${archive} ${TESTFILE}'
test_unpack test.rar test.in rar 'rar -idq a ${archive} ${TESTFILE}'

# TODO: .run/.sh/.bin

test_reject_junk .bz2
test_reject_junk .Z
test_reject_junk .gz
test_reject_junk .lzma
test_reject_junk .xz
test_reject_junk .lz
test_reject_junk .zst
test_reject_junk .tar
test_reject_junk .cpio
test_reject_junk .gpkg.tar
test_reject_junk .deb
test_reject_junk .zip
test_reject_junk .7z
test_reject_junk .rar
test_reject_junk .lha
test_reject_junk .lzh

DISTDIR=$(portageq envvar DISTDIR)
if [[ -n ${DISTDIR} ]]; then
	einfo "Using DISTDIR: ${DISTDIR}"
	if [[ ${UNPACKER_TESTS_ONLINE} != 1 ]]; then
		ewarn "Online tests will be skipped if distfiles are not found already."
		ewarn "Set UNPACKER_TESTS_ONLINE=1 to enable fetching."
	fi

	# NB: a good idea to list the last file in the archive (to avoid
	# passing on partial unpack)

	# TODO: find test cases for makeself 2.0/2.0.1, 2.1.1, 2.1.2, 2.1.3

	# makeself 1.5.4, gzip
	test_online \
		http://updates.lokigames.com/sof/sof-1.06a-cdrom-x86.run \
		f76f605af08a19b77548455c0101e03aca7cae69462914e47911da2fadd6d4f3b766e1069556ead0d06c757b179ae2e8105e76ea37852f17796b47b4712aec87 \
		update.sh \
		ba7a3f8fa79bbed8ca3a34ead957aeaa308c6e6d6aedd603098aa9867ca745983ff98c83d65572e507f2c3c4e0778ae4984f8b69d2b8279741b06064253c5788

	# makeself 1.6.0-nv*, xz
	test_online \
		https://download.nvidia.com/XFree86/Linux-x86/390.154/NVIDIA-Linux-x86-390.154.run \
		083d9dd234a37ec39a703ef7e0eb6ec165c24d2fcb5e92ca987c33df643d0604319eb65ef152c861acacd5a41858ab6b82c45c2c8ff270efc62b07727666daae \
		libEGL_nvidia.so.390.154 \
		6665804947e71fb583dc7d5cc3a6f4514f612503000b0a9dbd8da5c362d3c2dcb2895d8cbbf5700a6f0e24cca9b0dd9c2cf5763d6fbb037f55257ac5af7d6084

	# makeself 2.3.0, gzip
	test_online \
		http://www.sdrplay.com/software/SDRplay_RSP_API-Linux-3.07.1.run \
		059d9a5fbd14c0e7ecb969cd3e5afe8e3f42896175b443bdaa9f9108302a1c9ef5ad9769e62f824465611d74f67191fff71cc6dbe297e399e5b2f6824c650112 \
		i686/sdrplay_apiService \
		806393c310d7e60dca7b8afee225bcc50c0d5771bdd04c3fa575eda2e687dc5c888279a7404316438b633fb91565a49899cf634194d43981151a12c6c284a162

	# makeself 2.4.0, gzip
	test_online \
		http://www.sdrplay.com/software/SDRplay_RSP_API-Linux-2.13.1.run \
		7eff1aa35190db1ead5b1d96994d24ae2301e3a765d6701756c6304a1719aa32125fedacf6a6859d89b89db5dd6956ec0e8c7e814dbd6242db5614a53e89efb3 \
		sdrplay_license.txt \
		041edb26ffb75b6b59e7a3514c6f81b05b06e0efe61cc56117d24f59733a6a6b1bca73a57dd11e0774ec443740ca55e6938cf6594a032ab4f14b23f2e732a3f2
else
	ewarn "Unable to obtain DISTDIR from portageq, skipping online tests"
fi

texit
