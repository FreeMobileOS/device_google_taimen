#
# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if ! [ -d vendor/google_devices/taimen ]; then
	# https://developers.google.com/android/blobs-preview
	[ -e google_devices-taimen-4729765-58033fdf.tgz ] || wget https://dl.google.com/dl/android/aosp/google_devices-taimen-4729765-58033fdf.tgz
	[ -e qcom-taimen-4729765-bf7c6e45.tgz ] || wget https://dl.google.com/dl/android/aosp/qcom-taimen-4729765-bf7c6e45.tgz
	for i in *-taimen-*.tgz; do
		tar xf $i
	done
	mkdir tmp-bin
	# Replace real "more" with a cat wrapper so we don't have to fake
	# user input... (just ln -s cat tmp-bin/more will break things if
	# cat is toybox, busybox or another unified binary)
	echo 'exec cat "$@"' >tmp-bin/more
	chmod +x tmp-bin/more
	# And make sure we have GNU tar first on the path, the extract
	# scripts don't like libarchive tar at all
	which gtar 2>/dev/null && ln -s $(which gtar) tmp-bin/tar
	export PATH=`pwd`/tmp-bin:$PATH
	for i in extract-*-taimen.sh; do
		echo -e "\nI ACCEPT" |./$i
	done
	rm -rf tmp-bin
fi

add_lunch_combo aosp_taimen-userdebug
