# Story Line; Learn to use arrays and send an email to each person.

# Create the body of the email
$msg = "Hello there. This is my powershell message. Duane said I can send it."

# create an array of email addresses
$emailAddresses = @('dunston@champlain.edu','agoldstein@champlain.edu','christopher.mathieso@mymail.champlain.edu')

# Loop through the array
foreach ($email in $emailAddresses) {

    #write-host $email
    if ($email -eq "agoldstein@champlain.edu") {

        continue

    } else {

        write-host $email
        Send-MailMessage -from "flavorflava@fatgoldchain.gov" -to $email -Subject "Hey There." -Body $msg -SmtpServer "nickel.champlain.edu"
    }
    # Send the users an email containing the $msg.
    #Send-MailMessage -from "flavorflava@fatgoldchain.gov" -to $email -Subject "Hey There." -Body $msg -SmtpServer 192.168.1.32
}