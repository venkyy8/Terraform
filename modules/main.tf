
provider "aws"{

}
module "ec2_instance"{
    #source= "./modules/ec2_instance"
    #source= "C:\Users\yeduru.vr\Desktop\New folder"
    source= "C:/Users/yeduru.vr/Desktop/New folder"
    region     = "ap-south-1"
    access_key = "AKIAXMZNJW6PVJQBTD5Z"
    secret_key = "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"
    
}
