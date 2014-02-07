!/bin/ksh
#
# "wave" is a test signal generator, a script that generates a WAVE
# file of a duration of 1 minute containing a test signal calculated
# from three parameterized sine functions.
#
# Copyright (C) 2014  Cyrill Steiner
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
echo                                                                                                
echo                                                                                             
echo                                                                                                   
echo                                                                                             
echo ' wwwwwww           wwwww           wwwwwwwaaaaaaaaaaaaavvvvvvv           vvvvvvv eeeeeeeeeeee'    
echo '  w:::::w         w:::::w         w:::::w a::::::::::::av:::::v         v:::::vee::::::::::::ee'  
echo '   w:::::w       w:::::::w       w:::::w  aaaaaaaaa:::::av:::::v       v:::::ve::::::eeeee:::::ee'
echo '    w:::::w     w:::::::::w     w:::::w            a::::a v:::::v     v:::::ve::::::e     e:::::e'
echo '     w:::::w   w:::::w:::::w   w:::::w      aaaaaaa:::::a  v:::::v   v:::::v e:::::::eeeee::::::e'
echo '      w:::::w w:::::w w:::::w w:::::w     aa::::::::::::a   v:::::v v:::::v  e:::::::::::::::::e' 
echo '       w:::::w:::::w   w:::::w:::::w     a::::aaaa::::::a    v:::::v:::::v   e::::::eeeeeeeeeee'  
echo '        w:::::::::w     w:::::::::w     a::::a    a:::::a     v:::::::::v    e:::::::e'           
echo '         w:::::::w       w:::::::w      a::::a    a:::::a      v:::::::v     e::::::::e'          
echo '          w:::::w         w:::::w       a:::::aaaa::::::a       v:::::v       e::::::::eeeeeeee'  
echo '           w:::w           w:::w         a::::::::::aa:::a       v:::v         ee:::::::::::::e'  
echo '            www             www           aaaaaaaaaa  aaaa        vvv            eeeeeeeeeeeeee'
echo
echo
echo
echo '      * *                 * *                 * *                 * *                 * *    '
echo '    *     *             *     *             *     *             *     *             *     *  '
echo '   *       *           *       *           *       *           *       *           *       * '
echo '  +---------+---------+---------+---------+---------+---------+---------+---------+---------+'
echo '             *       *           *       *           *       *           *       *           '
echo '              *     *             *     *             *     *             *     *            '
echo '                * *                 * *                 * *                 * *              '
echo
echo                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
echo
echo '               This script generates a sine wave .wav sound file of 1 minute length'
echo
echo '              Offset and frequency of three sine waves can be entered as parameters'
echo '         The values of all three sine waveforms are added up to result in one sound signal'
echo
echo
echo 'Please enter frequency of wave no. 1 (reasonable values range from 50 to 20.000 Hertz)' 

read frequency1

echo 'Please enter offset of wave no. 1 (as a factor of one wavelength between 0 and 1)' 

read offsetfactor1

echo 'Please enter an amplitude factor for wave no. 1 (reasonable values range from 0 to 1)' 

read amplitude1

echo 'You entered a frequency of '$frequency1', an offset of '$offsetfactor1' and an elongation factor of '$amplitude1



echo 'Please enter frequency of wave no. 2 (reasonable values range from 50 to 20.000 Hertz)' 

read frequency2

echo 'Please enter offset of wave no. 2 (as a factor of one wavelength between 0 and 1)' 

read offsetfactor2

echo 'Please enter an amplitude factor for wave no. 2 (height of waveform, reasonable values range from 0 to 1)' 

read amplitude2

echo 'You entered a frequency of '$frequency2', an offset of '$offsetfactor2' and an elongation factor of '$amplitude2



echo 'Please enter frequency of wave no. 3 (reasonable values range from 50 to 20.000 Hertz)' 

read frequency3

echo 'Please enter offset of wave no. 3 (as a factor of one wavelength between 0 and 1)' 

read offsetfactor3

echo 'Please enter an amplitude factor for wave no. 3 (height of waveform, reasonable values range from 0 to 1)' 

read amplitude3

echo 'For sinewave 3 you can choose to add only positive, negative or all half waves to the result.'
echo 'Enter halfwave contribution to the result (positive, negative or all):'

read contribution3

echo 'You entered a frequency of '$frequency3', an offset of '$offsetfactor3', an elongation factor of '$amplitude3
echo 'and a contribution of '$contribution3' halfwaves'


echo 'Now file header is created...'

#
# To be able to easily write raw hex data into a file, a function is defined here:

writehex  ()
{
    while [ $1 ]; do
        for ((i=0; i<${#1}; i+=2))
        do
            printf "\x${1:i:2}";
        done;
        shift;
    done
}

#
# credits for this function goes to Dennis Williamson
# as posted here:"http://serverfault.com/questions/193952/writing-hex-values-to-a-file-not-as-ascii-values-via-the-command-line"
#
# Now we start with the generation of wave file header

#
# The first four hex figures designate the file container format used, which was

# termed RIFF (Resource Interchange File Format) by Microsoft, this field is called

# "ChunkID" and is four bytes long


writehex 52494646 > sinetone.wav


# The next header field is called "Chunksize"
# (defined as "whole file size" - ["ChunkID" + "Chunksize"] = "whole file size" - 8 bytes)
# To keep the skript easy to begin with, we generate a fixed file size, thus we do not need to caculate 
# final file size at runtime
# Let us agree to create exactly 5 Minutes of audio data.
# With this information we can determine the size of the audio raw data.
# We choose the standard audio sampling rate of 441000 Herz per second
# 5 Minutes consist of 5 times 60 seconds, gives us a total of 300 seconds
# we have 44100 x 300 Datapoints for one channel, we listen to stereo, thus we have two audio channels, this finally
# gives us a total of 44100 x 300 x 2 = 26'460'000 datapoints
# each datapoint is 2 bytes in size, thus we will have a final raw data size of
# 26'460'000 x 2 = 52'920'000 bytes, then we have 2 channels, gives us
# 52'920'000 x 2 = 105'840'000 bytes plus additional
# 40-8=32 bytes of header which makes up a total of 105'840'036 bytes
# Now we need to convert this value from decimal to hexadecimal: 105'840'036 (dec) = 06 4E FD A4 (hex)
#  is big endian, but the field "chunksize" is defined in little endian notation, this leaves us with: A4 FD 4E 06 

# O.K. here we go writing "chunksize"

# writehex E47E2703 >> sinetone.wav

writehex E47FA100 >> sinetone.wav

# the next field is the format field designates the format of data that follows, 
# in our case this is „WAVE“, other formats would also be possible in a RIFF file container
# thus we have to write ASCII hex code for the characters representing "WAVE" which is 57 41 56 45

writehex 57415645 >> sinetone.wav

# by definition, the „WAVE“ format requires two format specific subchunks, the describtive „fmt“ 
# subchunk and the „data“ subchunk that contains the actual audio raw data.
# Subchunk1ID is field of 4 bytes containing the three lower case letters „fmt“ followed 
# by the „space“ control command in hexadecimal ASCII format, f  m  t  SPACE = 66 6D 74 20

writehex 666D7420 >> sinetone.wav

# Subchunk1Size: this field contains the size of subchunk1 (minus size of subchunk1 header which is field Subchunk1ID)
# Subchunk1 field size is 4 Bytes in little endian notation. The residual size for subchunk1 is 16 Bytes in case of 
# PCM (pulse code modulation) this is the size of the rest of the Subchunk which follows this number, in case of 
# pulse code modulation PCM, Subchunk1 size is 16 Bytes, 16 (dec) = 10 (hex), 4 Bytes big endian hex: 00 00 00 10,
# 4 Bytes little endian hex: 10 00 00 00

writehex 10000000 >> sinetone.wav

# The next header field is called "AudioFormat", it is a little endian field of 2 Bytes, for PCM the value is 1 (i.e. 
# Linear quantization), values other than 1 indicate some form of compression, 1 (dec) = 1 (hex), 
# 2 Bytes big endian hex: 00 01, 2 Bytes little endian hex: 01 00

writehex 0100 >> sinetone.wav

# the header field "NumChannels" is self explanatory, is a little endian field of 2 Bytes and designates the number of 
# channels used, Mono = 1, Stereo = 2, etc., 2 (dec) = 2 (hex), 2 Bytes big endian hex: 00 02, 2 Bytes little endian hex: 02 00

writehex 0200 >> sinetone.wav

# The header field "SampleRate" is again self explanatory, it is a little endian field of 4 Bytes, it designates the sample rate 
# used, like 8000, 44100, 48000, etc., we use 44100, 44100 (dec) = AC44 (hex), 4 Bytes big endian hex: 00 00 AC 44,
# 4 Bytes little endian hex: 44 AC 00 00

writehex 44AC0000 >> sinetone.wav

# The "ByteRate" designates the byte rate and is a 4 byte little endian field
# SampleRate * NumChannels * BitsPerSample/8 = 44100 * 2 * 16/8 = 176'400
# 176'400 (dec) = 00 02 B1 10 (hex), little endian = 10 B1 02 00

writehex 10B10200 >> sinetone.wav

# The "BockAlign" field Block designates the number of bytes for one sample including all channels, it is a little endian 
# field of 2 Bytes, == NumChannels * BitsPerSample/8== 2 * 16 / 8 = 4, 4 (dec) = 4 (hex), 2 Bytes big endian hex: 00 04,
# 2 Bytes little endian hex: 04 00

writehex 0400 >> sinetone.wav

# The field "BitsPerSample" indicates the sampling resolution, little endian field of 2 Bytes, 8 bits = 8, 16 bits = 16, etc.,
# we use a resolution of 16 bit, 16 (dec) = 10 (hex), 2 Bytes big endian hex: 00 10, 2 Bytes little endian hex: 10 00

writehex 1000 >> sinetone.wav

# The „data“ subchunks contains the size information oft he sound information and the raw data, it starts with "Subchunk2ID"
# a field of 4 Bytes, the four lower case letters „data“ in hexadecimal ASCII form (big endian), d  a  t  a = 64 61 74 61

writehex 64617461 >> sinetone.wav

# Last but not least there is the field "Subchunk2Size": field of 4 Bytes, this is the number of bytes in the data,
# you can also think of this as the size of the read of the subchunk following this number
# == NumSamples * NumChannels * BitsPerSample/8
# for one second of a 44100 sample rate this is: 44100 * 2 * 16 / 8 = 176400
# thus, 176400 (hex) = 2B110 (dec) 4 Bytes big endian hex: 00 02 B1 10, 4 Bytes little endian hex: 10 B1 02 00

writehex C07FA100 >> sinetone.wav

# that's it folks, we are done with the header, calculation of the raw data can start

echo 'creation of file header is has completed'
echo 'comencing calculation of raw data ...'

# setting constants to defined values

x=0
y=0
z=0
u=0
s=0
S=0

# Setting constant Pi

((Pi=acos(-1)))

# Expanding variables y,z,s to floating point variables, setting S to integer

typeset -F y
typeset -F z
typeset -F u
typeset -F s
typeset -i S

# calculating the offset for the three sinewaves based on frequency and offset factor

offset1=(1/frequency1*offsetfactor1)
offset2=(1/frequency2*offsetfactor2)
offset3=(1/frequency3*offsetfactor3)


# Starting mainloop to calculate sinewave values and writing to wave file

for i in {1..2646000}

# Calculating first sine curve

do ((y=sin((x+offset1)*2*frequency1*Pi/44100)));
y=y*amplitude1;

# Calculating second sine curve

((z=sin((x+offset2)*2*frequency2*Pi/44100)));
z=z*amplitude2;

# Calculating third sine curve

((u=sin((x+offset3)*2*frequency3*Pi/44100)));
u=u*amplitude3;

# halfwave cancelation

case $contribution3 in
negative);
if [ u -lt 0 ];
then let u=0;
echo 'negative';
echo 'Der Wert von u ist gleich '$u;
fi;
;;
positive);
if [ u -gt 0 ];
then let u=0;
echo 'positive';
echo 'Der Wert von u ist gleich '$u;
fi;
;;
esac;


# Adding up the three values to a resulting curve
# and normalizing it to 1 (by dividing by 3)
# and normalizing it to 32767 (by multiplying by 32767)

((s=((y+z+u)/3*32767)));

# sine function generates flowting point figures
# but we need integer thus in this step we we do the
# rounding to integer
echo 'S='$S 'und s='$s;
((S=s+,5));

echo 's nicht gerundet ist gleich: '$s
echo 'S gerundet ist gleich: '$S
 
# transforming S from -32768 to 32767 singed integer to
# 0 - 65535 unsigned integer
if [ S -lt 0 ];
then let S=S+65536;
fi;

# converting from decimal to hexadecimal

hexS=0;

hexS=$(printf "%04X\n" $S);

echo 'hexS = '$hexS;

# now lets convert from big to little endian
# by cropping hexS and rearrange left and right part

hex_left=${hexS:0:2};

hex_right=${hexS:2:2};

echo 'hex_left = '$hex_left;

echo 'hex_right = '$hex_right; 

hexS_swapped=$hex_right$hex_left;

echo 'hexS_swapped = '$hexS_swapped;

# now the figure has the proper little endian
# hex format and can be written to the file

writehex $hexS_swapped >> sinetone.wav;
writehex $hexS_swapped >> sinetone.wav;

echo 'Der unsigned Integer Wert von S ist gleich: '$S;

let x=x+1;

done;







